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
    
    var networkList = [String]()
    
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
    
    /** Triggered when user clicks the `Select folder` button. */
    @IBAction func selectFolderClicked(_ sender: NSButton) {
        
        let pathPicker = NSOpenPanel()
        
        pathPicker.allowsMultipleSelection = false
        pathPicker.canChooseFiles = false
        pathPicker.canChooseDirectories = true
        
        pathPicker.runModal()
        
        if let chosenPath = pathPicker.url?.absoluteString {
            
            print(chosenPath)
            let pathToDisplay = chosenPath.stringByReplacingFirstOccurrenceOfString(target: "file://", withString: ""
            )
            pathLbl.stringValue = pathToDisplay
        }
    }
}

extension AddSetupVC {
    
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
     */
    fileprivate func checkIfNetworkAndPathPresent(){
        
        //TODO: write check code
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
    
    fileprivate func setupTableView(){
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return networkList.count
    }
    
    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        
        let cell = NSCell()
        cell.title = networkList[row]
        
        return cell
    }
}
