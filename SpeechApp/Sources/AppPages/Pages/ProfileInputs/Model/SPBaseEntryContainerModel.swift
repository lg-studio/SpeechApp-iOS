//
//  SPBaseEntryContainerModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseEntryContainerModel: NSObject {
    var profileInfo : [SPProfileEntryModel];
    
    var jsonToSend      : NSMutableDictionary?;
    var filesToUpload   : [String]?;

    override init() {
        self.profileInfo = [];
        super.init();
    }
    
    func getEntryModelIndexFromKey (key : String) -> Int {
        var index = 0;
        for entryModel in self.profileInfo {
            if entryModel.entryKey == key {
                return index;
            }
            index++;
        }
        
        return -1;
    }
    func allRequiredFieldsCompleted() -> Bool {
        for entryModel in self.profileInfo {
            if entryModel.required && entryModel.isValid() == false {
                return false;
            }
        }
        return true;
    }
    
    
    func buildDataToSendToServer() {
        self.jsonToSend = NSMutableDictionary();
        self.filesToUpload = [];
        
        for entryModel in self.profileInfo {
            switch entryModel.type {
            case .TextName, .TextEmail, .TextPassword, .Choice:
                if let valueInt = entryModel.value as? Int {
                    jsonToSend?.setObject(valueInt, forKey: entryModel.entryKey);
                }
                else if let valueStr = entryModel.value as? String {
                    jsonToSend?.setObject(valueStr, forKey: entryModel.entryKey);
                }
                break;
            case .Image:
                if let imagePath = entryModel.value as? String {
                    if NSFileManager.defaultManager().fileExistsAtPath(SPUtils.getFullPathFromNSDocuments(imagePath)) {
                        filesToUpload?.append(imagePath);
                    }
                }
                break;
            default:
                break;
            }
        }
    }
}
