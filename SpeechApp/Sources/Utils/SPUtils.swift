//
//  SPUtils.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class SPUtils: NSObject {
    static let LOGOUT_NOTIFICATION = "LogoutNotification";
    
    static func displayErrorAlertController(error : String, viewController : UIViewController) {
        SPUtils.displayAlertController("Error", message: error, viewController: viewController);
    }
    static func displayAlertController(title : String, message : String, viewController : UIViewController) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        viewController.presentViewController(alert, animated: true, completion: nil);
    }
    static func deviceIsConnectedOverWiFi() -> Bool {
        let reachability = Reachability.reachabilityForInternetConnection();
        reachability.startNotifier();
        reachability.currentReachabilityStatus;
        
        switch(reachability.currentReachabilityStatus) {
        case Reachability.NetworkStatus.ReachableViaWiFi:
            return true;
        default:
            return false;
        }
    }
    static func formatMinutes(minutes : Int) -> String {
        let min:Int = Int(minutes / 60)
        let sec:Int = Int(minutes % 60)
        return String(format: "%d:%02d h", min, sec);
    }
    static func getFullPathFromNSDocuments(fileName : String) -> String {
        var documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0];
        let path = documents.stringByAppendingString(String(format : "/%@", fileName));
        return path;
    }
    static func deleteFilesFromDocumentsDirectory(pathsToErase : [String]) {
        let fileManager = NSFileManager.defaultManager();
        var error : NSError?;

        for filePath in pathsToErase {
            fileManager.removeItemAtPath(SPUtils.getFullPathFromNSDocuments(filePath), error: &error);
        }
    }
    static func convertAnyObjectToString(value : AnyObject) -> String {
        if let intValue = value as? Int {
            return String(format:"%d", intValue);
        }
        else if let strValue = value as? String {
            return strValue;
        }
        return "";
    }
    static func compareObjects(obj1 : AnyObject, obj2 : AnyObject) -> Bool {
        if let obj1Int = obj1 as? Int {
            if let obj2Int = obj2 as? Int {
                if obj1Int == obj2Int {
                    return true;
                }
            }
        }
        if let obj1Str = obj1 as? String {
            if let obj2Str = obj2 as? String {
                if obj1Str == obj2Str {
                    return true;
                }
            }
        }
        return false;
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return emailTest.evaluateWithObject(testStr);
    }
    
    static func concatenateStrings(string1 : String?, string2 : String?) -> String {
        var out = "";
        if string1 != nil && string1?.length > 0 {
            out = string1!;
        }
        if string2 != nil && string2?.length > 0 {
            if out.length > 0 {
                out = String(format: "%@ ", out);
            }
            out = String(format: "%@%@", out, string2!);
        }
        return out;
    }
}