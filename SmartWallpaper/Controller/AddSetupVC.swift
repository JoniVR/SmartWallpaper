// MIT License
//
// Copyright (c) 2017 Joni Van Roost
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa

class AddSetupVC: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var pathLbl: NSTextField!
    @IBOutlet weak var addBtn: NSButton!
    @IBOutlet weak var changeWallpaperBtn: NSButton!
    @IBOutlet weak var changeWallpaperIntervalPopup: NSPopUpButton!
    @IBOutlet weak var shuffleWallpaperBtn: NSButton!
    
    /// An array of Strings that is used to store the names of previously connected networks.
    fileprivate var networkList = [String]()
    /// A string that stores the network name selected by the user.
    fileprivate var selectedNetworkName: String?
    /// A String that stores the path the user has selected.
    fileprivate var selectedPath: String?
    /// The Wallpaper `RotationMode` that the user can select using the `changeWallpaperIntervalPopup`. The default is `.login`.
    fileprivate var selectedRotationMode: RotationMode? = .login
    
    /**
    The delegate for adding a NetworkSetup.
    The delegate must conform to the `AddNetworkSetupDelegate` protocol.
    */
    public weak var delegate: AddNetworkSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.isEnabled = false
        getNetworkList()
        setupTableView()
        setupPopUpButton()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // MARK: Prevent resizing
        view.window!.styleMask.remove(NSWindow.StyleMask.resizable)
    }
    
    /// Remove the `addSetup` sheet without adding a setup.
    @IBAction func cancelClicked(_ sender: NSButton) {
        
        self.dismiss(sender)
    }
    
    @IBAction func addClicked(_ sender: NSButton) {
        
        /*
         TODO:
         - check if NetworkSetup already exists before adding.
         - move and refactor runScript code.
         */
        
        // When we select an interval we set the selectedRotationMode to interval
        if (selectedRotationMode!.rawValue >= 2) {
            selectedRotationMode = .interval
        }
        
        let networkSetupToAdd = NetworkSetup(selectedPath: selectedPath!,
                                             networkName: selectedNetworkName!,
                                             rotationMode: selectedRotationMode!,
                                             randomOrder: shuffleWallpaperBtn.isFlipped,
                                             interval: selectedRotationMode!.getAsInterval())
        
        delegate?.didAddSetup(networkSetup: networkSetupToAdd)
        
        self.dismiss(sender)
    }
    
    /// Triggered when user clicks the `Select folder` button.
    @IBAction func selectFolderClicked(_ sender: NSButton) {
        
        let pathPicker = NSOpenPanel()
        
        pathPicker.allowsMultipleSelection = false
        pathPicker.canChooseFiles = false
        pathPicker.canChooseDirectories = true
        
        pathPicker.runModal()
        
        if let chosenPath = pathPicker.url?.absoluteString {
            
            selectedPath = chosenPath.stringByReplacingFirstOccurrenceOfString(target: "file://", withString: ""
            )
            pathLbl.stringValue = selectedPath!
            checkIfNetworkAndPathPresent()
        }
    }
    
    @IBAction func changeWallpaperClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            changeWallpaperIntervalPopup.isEnabled = true
            shuffleWallpaperBtn.isEnabled = true
            selectedRotationMode = RotationMode(rawValue: changeWallpaperIntervalPopup.selectedItem!.tag)
        } else {
            changeWallpaperIntervalPopup.isEnabled = false
            shuffleWallpaperBtn.isEnabled = false
            selectedRotationMode = .off
        }
    }
    
    /**
     Gets called when a `NSMenuItem` inside the `changeWallpaperIntervalPopup` gets clicked.
     - parameter sender: The NSMenuItem that is clicked.
     */
    @objc func popupItemClicked(_ sender: NSMenuItem){
        
        selectedRotationMode = RotationMode(rawValue: sender.tag)
    }
}

extension AddSetupVC {
    
    /**
     This function is used to fetch the list of previously connected networks.
     We do this using the bash command line with the command:
     ```
     defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences | grep SSIDString
     ```
     After getting a network name, we remove prefix and suffix from the result and add the network name (String) to the `networkList`.
     */
    fileprivate func getNetworkList(){
        
        let (output, terminationStatus) = shell(arguments: ["-c", "defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences | grep SSIDString"])
        if (terminationStatus == 0) {
            let arrayOfWifi = output?.components(separatedBy: CharacterSet.newlines)
            
            for var aWifi in arrayOfWifi! {
                aWifi = aWifi.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if (aWifi.hasPrefix("SSIDString = ")) {
                    aWifi = aWifi.stringByReplacingFirstOccurrenceOfString(target: "SSIDString = ", withString: "")
                }
                if (aWifi.hasPrefix("\"")) {
                    aWifi = aWifi.stringByReplacingFirstOccurrenceOfString(target: "\"", withString: "")
                }
                if (aWifi.hasSuffix("\";")) {
                    aWifi = aWifi.stringByReplacingLastOccurrenceOfString(target: "\";", withString: "")
                }
                if (aWifi.hasSuffix(";")) {
                    aWifi = aWifi.stringByReplacingLastOccurrenceOfString(target: ";", withString: "")
                }
                aWifi = aWifi.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                networkList.append(aWifi)
            }
        }
    }
    
    /**
     Used to check if all required values have been entered before we add the setup.
     We also enable/disable the "Add" button here.
     */
    fileprivate func checkIfNetworkAndPathPresent(){
        
        //TODO: write check code
        if (selectedNetworkName != nil && selectedPath != nil) {
            addBtn.isEnabled = true
        } else {
            addBtn.isEnabled = false
        }
    }
    
    /**
     This function executes an AppleScript that changes the wallpaper folder and settings.
     - parameter path: The path (as String) used to describe the image folder that will be used for the wallpapers.
     - parameter rotation: The rotation mode of the wallpapers:
         - 0 = off
         - 1 = interval
         - 2 = login
         - 3 = sleep
     - parameter randomOrder: Determines if the wallpaper rotation should be random or not.
     - parameter interval: The interval (in seconds) at which the desktops will change (in case rotation mode is set to 1, interval).
    */
    fileprivate func runScript(path: String, rotation: Int, randomOrder: Bool, interval: CGFloat){
        
        let myAppleScript =
        "try\n " +
            "tell application \"System Events\"\n" +
                "tell every desktop\n" +
                    "set picture rotation to \(rotation)\n" +
                    "set random order to \(randomOrder)\n" +
                    "set pictures folder to \"\(path)\"\n" +
                    "set change interval to \(interval)\n" +
                "end tell\n" +
            "end tell\n" +
        "end try"
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            scriptObject.executeAndReturnError(nil)
        }
    }
    
    /// Setting up the options for the `changeWallpaperIntervalPopup`.
    fileprivate func setupPopUpButton(){
        
        let menu = NSMenu()
        let titles = ["At login","After sleep","Every 5 seconds","Every minute","Every 5 minutes","Every 15 minutes","Every half hour","Every hour","Every day"]
        // MARK: We use this to assign tags that match the respective RotationMode value to each title, since values "off" and "interval" are not in the list we start from 2.
        var i = 2
        
        for title in titles {
            
            let item = NSMenuItem(title: title, action: #selector(popupItemClicked(_:)), keyEquivalent: "")
            item.tag = i
            menu.addItem(item)
            i+=1
            
            // Add a separator between "After sleep" and "Every 5 seconds"
            if i == 4 { menu.addItem(NSMenuItem.separator()) }
        }
        changeWallpaperIntervalPopup.menu = menu
    }
}

extension AddSetupVC: NSTableViewDelegate, NSTableViewDataSource {
    
    /// Used for up tableView.
    fileprivate func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return networkList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView {
            cell.textField?.stringValue = networkList[row]
            return cell
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        selectedNetworkName = networkList[tableView.selectedRow]
        checkIfNetworkAndPathPresent()
    }
}
