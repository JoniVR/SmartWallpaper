//
//  StringsExtensions.swift
//  SmartWallpaper
//
//  Created by Joni Van Roost on 16/11/17.
//  Copyright © 2017 Joni Van Roost. All rights reserved.
//

import Foundation

extension String {
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}

extension String {
    func stringByReplacingLastOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target, options: String.CompareOptions.backwards) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
}
