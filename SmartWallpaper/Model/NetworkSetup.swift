//
//  NetworkSetup.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 25/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Foundation

/**
 The way wallpapers are rotated.
 - off: No wallpaper rotation is applied.
 - interval: Wallpaper rotation is based on an interval (see `interval` property).
 - login: Wallpapers change when a user logs in.
 - sleep: Wallpapers change when the device comes out of sleep.
 */
enum RotationMode: Int {
    case off
    case interval
    case login
    case sleep
}

/**
 An object that stores a SmartWallpaper setup.
 
 This class inherits from NSObject and implements NSCoding.
 
 Objects of this class can be encoded and decoded.
 
        let networkSetupData = NSKeyedArchiver.archivedDataWithRootObject(networkSetup)
        let networkSetup = NSKeyedUnarchiver.unarchiveObjectWithData(networkSetupData) as! networkSetup
 */
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
    init(selectedPath: String, networkName: String, rotationMode: RotationMode, randomOrder: Bool, interval: CGFloat) {
        
        self.name = networkName
        self.path = selectedPath
        self.rotation = rotationMode
        self.randomOrder = randomOrder
        self.interval = interval
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(path, forKey: "path")
        aCoder.encode(rotation, forKey: "rotation")
        aCoder.encode(randomOrder, forKey: "randomOrder")
        aCoder.encode(interval, forKey: "interval")
    }
    
    public required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let path = aDecoder.decodeObject(forKey: "path") as! String
        let rotation = aDecoder.decodeObject(forKey: "rotation") as! RotationMode
        let randomOrder = aDecoder.decodeBool(forKey: "randomOrder")
        let interval = aDecoder.decodeObject(forKey: "interval") as! CGFloat
        self.init(selectedPath: path, networkName: name, rotationMode: rotation, randomOrder: randomOrder, interval: interval)
    }
}
