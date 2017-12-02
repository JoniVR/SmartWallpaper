//
//  MainWindowController.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 2/12/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier?._rawValue == "AddSetupSegue" {
            if let destination = segue.destinationController as? AddSetupVC {
                
                // Assign the AddnetWorkSetupDelegate
                destination.delegate = self
            }
        }
    }
}

extension MainWindowController: AddNetworkSetupDelegate {
    
    func didAddSetup(networkSetup: NetworkSetup) {
        
        if let homeVC = self.contentViewController as? HomeVC {
            homeVC.networkSetupList.append(networkSetup)
            homeVC.tableView.reloadData()
        }
    }
}
