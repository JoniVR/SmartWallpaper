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
import Foundation

class HomeVC: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var removeSetupBtn: NSButton!
    
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
    
    @IBAction func removePressed(_ sender: NSButton) {
        
        // remove a selected setup (-1 means no row selected).
        if tableView.selectedRow != -1 {
            networkSetupList.remove(at: tableView.selectedRow)
            tableView.reloadData()
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
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        
        // TODO: sort by name
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        // make sure remove setup button is only enabled when a setup is currently selected.

        if tableView.selectedRow == -1 {
            removeSetupBtn.isEnabled = false
        } else {
            removeSetupBtn.isEnabled = true
        }
    }
}
