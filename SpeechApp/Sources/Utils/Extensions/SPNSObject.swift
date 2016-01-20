//
//  SPNSObject.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 09/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension NSObject {
    func lock(handle : AnyObject, body : () -> ()) {
        objc_sync_enter(handle);
        body();
        objc_sync_exit(handle);
    }
    
    func getDefaultAppColor() -> UIColor {
        return UIColor( red: 36/255, green: 102/255, blue:4/255, alpha: 1.0 );
    }
    
    func getTimestampString(timestamp : Double) -> String {
        var date = NSDate(timeIntervalSince1970: NSTimeInterval(timestamp / 1000.0));
        let formattedTime = NSDateFormatter.localizedStringFromDate(date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        return formattedTime;
    }
    
    func computePercentageString(value : Double) -> String {
        return String(format : "%d%%", Int(value * 100.0));
    }
}
