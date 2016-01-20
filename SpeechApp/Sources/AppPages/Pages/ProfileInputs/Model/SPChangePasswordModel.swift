//
//  SPChangePasswordModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChangePasswordModel: SPBaseEntryContainerModel {
    
    override init() {
        super.init();
        self.generateChangePasswordInfo();
    }
    
    
    private func generateChangePasswordInfo() {
        self.profileInfo.append(SPProfileEntryModel(type: .TextPassword, value:nil, entryKey: "OldPassword", displayName: "Old Password", required : true, choiceGeneratorModel: nil));
        self.profileInfo.append(SPProfileEntryModel(type: .TextPassword, value:nil, entryKey: "NewPassword", displayName: "New Password", required : true, choiceGeneratorModel: nil));
        self.profileInfo.append(SPProfileEntryModel(type: .TextPassword, value:nil, entryKey: "NewPassword", displayName: "Confirm New Password", required : true, choiceGeneratorModel: nil));
        
        
        // submit button
        self.profileInfo.append(SPProfileEntryModel(type: .Submit, value:nil, entryKey: "Submit", displayName: "Update Password", required : false, choiceGeneratorModel: nil));
    }
    
    func getOldPassword() -> String {
        if let oldPassword = self.profileInfo[0].value as? String {
            return oldPassword;
        }
        return "";
    }
    func getNewPassword() -> String {
        if let newPassword = self.profileInfo[1].value as? String {
            return newPassword;
        }
        return "";
    }
    
    func checkSamePassword() -> Bool {
        let passwd: AnyObject? = self.profileInfo[1].value;
        let passwdConfirm: AnyObject? = self.profileInfo[2].value;
        if passwd == nil || passwdConfirm == nil {
            return false;
        }
        return SPUtils.compareObjects(passwd!, obj2: passwdConfirm!);
    }
}
