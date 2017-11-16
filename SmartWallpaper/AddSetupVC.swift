//
//  AddSetupVC.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 15/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Cocoa

class AddSetupVC: NSViewController {

    @IBOutlet weak var tableView: NSScrollView!
    @IBOutlet weak var pathLbl: NSTextField!
    @IBOutlet weak var addBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // MARK: Prevent resizing
        view.window!.styleMask.remove(NSWindow.StyleMask.resizable)
        addBtn.isEnabled = false
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
        
        if let chosenPath = pathPicker.url {
            
            print(chosenPath)
            pathLbl.stringValue = chosenPath.absoluteString
        }
    }
}

extension AddSetupVC {
    
    /**
     Used to check if all required values have been entered before we add the setup.
     */
    fileprivate func checkIfNetworkAndPathPresent(){
        
        //TODO: write check code
        //if pathLbl.stringValue != nil
    }
}

extension AddSetupVC: NSTableViewDelegate, NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: NSTableView, dataCellFor tableColumn: NSTableColumn?, row: Int) -> NSCell? {
        
        return NSCell()
    }
}
