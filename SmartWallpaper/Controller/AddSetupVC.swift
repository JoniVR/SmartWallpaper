//
//  AddSetupVC.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 15/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

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
        if let homeVC = self.parent as? HomeVC {
            
            let networkSetup = NetworkSetup(selectedPath: selectedPath!, networkName: selectedNetworkName!, rotationMode: .interval, randomOrder: shuffleWallpaperBtn.isFlipped, interval: 60.0)
            homeVC.networkSetupList.append(networkSetup)
        }
        
        //runScript(path: selectedPath!, rotation: 1, randomOrder: true, interval: 60.0)
        
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
        } else {
            changeWallpaperIntervalPopup.isEnabled = false
            shuffleWallpaperBtn.isEnabled = false
        }
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
    
    /// This function is used to execute shell commands.
    fileprivate func shell(arguments: [String] = []) -> (String? , Int32) {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        let terminationStatus = task.terminationStatus
        return (output, terminationStatus)
    }
    
    /// Setting up the options for the `changeWallpaperIntervalPopup`.
    fileprivate func setupPopUpButton(){
        
        changeWallpaperIntervalPopup.removeAllItems()
        let items = ["At login","After sleep","Every 5 seconds","Every minute","Every 5 minutes","Every 15 minutes","Every half hour","Every hour","Every day"]
        changeWallpaperIntervalPopup.addItems(withTitles: items)
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
