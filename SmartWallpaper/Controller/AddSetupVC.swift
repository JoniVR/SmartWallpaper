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
    
    /** An array of Strings that is used to store the names of previously connected networks. */
    fileprivate var networkList = [String]()
    /** A string that stores the network name selected by the user. */
    fileprivate var selectedNetworkName: String?
    /** a String that stores the path the user has selected */
    fileprivate var selectedPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.isEnabled = false
        getNetworkList()
        setupTableView()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // MARK: Prevent resizing
        view.window!.styleMask.remove(NSWindow.StyleMask.resizable)
    }
    
    /** Remove the `addSetup` sheet without adding a setup. */
    @IBAction func cancelClicked(_ sender: NSButton) {
        
        self.dismiss(sender)
    }
    
    @IBAction func addClicked(_ sender: NSButton) {
        
        // TODO: write code to add to list.
        self.dismiss(sender)
    }
    
    /** Triggered when user clicks the `Select folder` button. */
    @IBAction func selectFolderClicked(_ sender: NSButton) {
        
        let pathPicker = NSOpenPanel()
        
        pathPicker.allowsMultipleSelection = false
        pathPicker.canChooseFiles = false
        pathPicker.canChooseDirectories = true
        
        pathPicker.runModal()
        
        if let chosenPath = pathPicker.url?.absoluteString {
            
            selectedPath = chosenPath
            let pathToDisplay = chosenPath.stringByReplacingFirstOccurrenceOfString(target: "file://", withString: ""
            )
            pathLbl.stringValue = pathToDisplay
            checkIfNetworkAndPathPresent()
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
     This function is used to execute shell commands
     */
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
}

extension AddSetupVC: NSTableViewDelegate, NSTableViewDataSource {
    
    /** Setting up tableView */
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
