//
//  NetworkSetup.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 25/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Foundation

enum RotationMode: Int {
    case off
    case interval
    case login
    case sleep
}

class NetworkSetup {
    
    fileprivate var name: String!
    fileprivate var path: String!
    fileprivate var rotation: RotationMode!
    fileprivate var randomOrder: Bool!
    fileprivate var interval: CGFloat!
    
    /**
     Initialize a network object.
     - parameter selectedPath: The path of the folder that will be used to display the wallpapers.
     - parameter networkName: The name of the network that is used to use a certain set of wallpapers.
     - paramater rotationMode: The mode at which wallpapers will be rotated. (see `RotationMode` enum).
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
}
