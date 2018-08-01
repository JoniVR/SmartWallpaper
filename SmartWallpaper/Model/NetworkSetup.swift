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

/**
 An object that stores a SmartWallpaper setup.
 
 This class inherits from NSObject and implements NSCoding.
 
 Objects of this class can be encoded and decoded.
 ```
 let networkSetupData = NSKeyedArchiver.archivedDataWithRootObject(networkSetup)
 let networkSetup = NSKeyedUnarchiver.unarchiveObjectWithData(networkSetupData) as! networkSetup
 ```
 */

import Foundation

class NetworkSetup: NSObject, NSCoding {
    
    /// The name of the selected network that is used to link a specific path.
    public private(set) var name: String!
    /// The path of the folder that stores the wallpapers that will be used.
    public private(set) var path: String!
    /// The rotation mode determines when the wallpapers change.
    public private(set) var rotation: RotationMode!
    /// Determines if the wallpapers will change in order or randomly.
    public private(set) var randomOrder: Bool!
    /// The interval time between wallpaper changes.
    public private(set) var interval: CGFloat!
    
    /**
     Initialize a network object.
     - parameter selectedPath: The path of the folder that will be used to display the wallpapers.
     - parameter networkName: The name of the network that is used to use a certain set of wallpapers.
     - parameter rotationMode: The mode at which wallpapers will be rotated. (see `RotationMode` enum).
     - parameter randomOrder: A `Bool` that indicates if the wallpapers are rotated at random or not.
     - parameter interval: A `CGFloat` that defines the time between changing wallpapers.
     */
    init(selectedPath: String, networkName: String, rotationMode: RotationMode?, randomOrder: Bool, interval: CGFloat) {
        
        self.name = networkName
        self.path = selectedPath
        self.rotation = rotationMode
        self.randomOrder = randomOrder
        self.interval = interval
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(path, forKey: "path")
        aCoder.encode(rotation.rawValue, forKey: "rotation")
        aCoder.encode(randomOrder, forKey: "randomOrder")
        aCoder.encode(interval, forKey: "interval")
    }
    
    public required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let path = aDecoder.decodeObject(forKey: "path") as! String
        let rotation = RotationMode(rawValue: aDecoder.decodeInteger(forKey: "rotation")) ?? .off
        // MARK: For some reason decodeBool crashes (because it interprets as Int?).
        let randomOrder = aDecoder.decodeObject(forKey: "randomOrder") as! Bool
        let interval = aDecoder.decodeObject(forKey: "interval") as! CGFloat
        self.init(selectedPath: path, networkName: name, rotationMode: rotation, randomOrder: randomOrder, interval: interval)
    }
}
