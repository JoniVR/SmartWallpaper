//
//  HomeVC.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 15/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Cocoa
import Foundation

class HomeVC: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    /**
     An array that stores all `NetworkSetup` objects.
     This array is stored inside UserDefaults.
     */
    public var networkSetupList: [NetworkSetup] {
        get {
            if let setupList = UserDefaults.standard.array(forKey: "setupList") as? [Data] {
                // Decode NSData into NetworkSetup object.
                return setupList.map({NSKeyedUnarchiver.unarchiveObject(with: $0) as! NetworkSetup})
            } else {
                return []
            }
        }
        set {
            // Encode NetworkSetup object.
            let setupList = newValue.map({ NSKeyedArchiver.archivedData(withRootObject: $0) })
            UserDefaults.standard.set(setupList, forKey: "setupList")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override var representedObject: Any? {
        didSet {
            
            // Update the view, if already loaded.
        }
    }
}

extension HomeVC: NSTableViewDelegate, NSTableViewDataSource {
    
    /// Used for setting up the tableView.
    fileprivate func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return networkSetupList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let networkSetup = networkSetupList[row]
        
        if let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView {
            
            if (tableColumn?.identifier)!.rawValue == "NetworkName" {
                cell.textField?.stringValue = networkSetup.name
            }
            
            if (tableColumn?.identifier)!.rawValue == "Path" {
                cell.textField?.stringValue = networkSetup.path
            }
            return cell
        }
        return nil
    }
}
