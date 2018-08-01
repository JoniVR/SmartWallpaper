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

import Foundation

/**
 The way wallpapers are rotated.
 
 **AppleScript Rotation modes**
 - 0 = off: No wallpaper rotation is applied.
 - 1 = interval: Wallpaper rotation is based on an interval (see `interval` property).
 - 2 = login: Wallpapers change when a user logs in.
 - 3 = sleep: Wallpapers change when the device comes out of sleep.
 */
enum RotationMode: Int {
    
    case off = 0
    case interval
    case login
    case sleep
    case everyFiveSeconds
    case everyMinute
    case everyFiveMinutes
    case everyFifteenMinutes
    case everyThirtyMinutes
    case everyHour
    case everyDay
    
    func getAsInterval() -> CGFloat {
        switch self {
        case .everyFiveSeconds:     return 5.0
        case .everyMinute:          return 60.0
        case .everyFiveMinutes:     return 300.0
        case .everyFifteenMinutes:  return 900.0
        case .everyThirtyMinutes:   return 1800.0
        case .everyHour:            return 3600.0
        case .everyDay:             return 86400.0
        default:                    return 0.0
        }
    }
}
