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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
}
