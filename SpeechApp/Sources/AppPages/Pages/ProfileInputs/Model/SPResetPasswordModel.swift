//
//  SPResetPasswordModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPResetPasswordModel: SPBaseEntryContainerModel {
    
    override init() {
        super.init();
        
        self.generateDefaultResetPasswordInfo();
    }
    
    private func generateDefaultResetPasswordInfo() {
        // email
        self.profileInfo.append(SPProfileEntryModel(type: .TextEmail, value:nil, entryKey: "Email", displayName: "Email", required : true, choiceGeneratorModel: nil));
        
        // submit button
        self.profileInfo.append(SPProfileEntryModel(type: .Submit, value:nil, entryKey: "Submit", displayName: "Reset Password", required : false, choiceGeneratorModel: nil));
    }
    
    func getEmail() -> String {
        if let email = self.profileInfo[0].value as? String {
            return email;
        }
        return "";
    }
}
