//
//  ViewController.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 15/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Cocoa

class HomeVC: NSViewController {
    
    /**
     An array that stores all `NetworkSetup` objects.
     */
    public var networkSetupList = [NetworkSetup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
            
        }
    }
}

