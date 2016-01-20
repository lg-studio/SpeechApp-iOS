//
//  THAHttpMockUtilities.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class THAHttpMockUtilities: THAHttpUtilities {
    override func get(methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        self.parseResponse(methodName, onError: onError, onSuccess: onSuccess);
    }
    
    
    override func post(methodName : String, parameters : Dictionary<String,AnyObject>?, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        self.parseResponse(methodName, onError: onError, onSuccess: onSuccess);
    }
    
    private func parseResponse(methodName: String, onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            var resourceName = methodName.stringByReplacingOccurrencesOfString(".json", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil);
            resourceName = resourceName.stringByReplacingOccurrencesOfString("/", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil);
            let filePath = NSBundle.mainBundle().pathForResource(resourceName, ofType: "json");
            if filePath == nil {
                let errorString = String(format : "[Mock Error] Resource %@ not defined inside the app",  resourceName);
                println(errorString);
                onError(.UNKNOWN_STATUS_CODE, errorString);
                return;
            }
            let jsonData = NSData(contentsOfFile: filePath!, options: .DataReadingMappedIfSafe, error: nil);
            let gameConfigArray = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary;
            onSuccess(gameConfigArray!["Data"] as! NSObject);
        };
    }
    
    override func postFilesWithJson(methodName : String, jsonName : String, json : NSDictionary, filePaths : [String], onError : ((THAHttpStatus, String) -> Void), onSuccess : ((NSObject) -> Void)) {
        self.parseResponse(methodName, onError: onError, onSuccess: onSuccess);
    }
}