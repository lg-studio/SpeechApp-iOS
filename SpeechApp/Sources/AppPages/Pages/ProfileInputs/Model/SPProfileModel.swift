//
//  SPProfileModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileModel: SPBaseEntryContainerModel {
    
    override init() {
        super.init();
        
        self.generateDefaultProfileInfo();
    }
    
    
    private func generateDefaultProfileInfo() {
        self.profileInfo.append(SPProfileEntryModel(type: .TextName, value:nil, entryKey: "FirstName", displayName: "First Name", required : true, choiceGeneratorModel: nil));
        self.profileInfo.append(SPProfileEntryModel(type: .TextName, value:nil, entryKey: "LastName", displayName: "Last Name", required : true, choiceGeneratorModel: nil));
        // year born
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:nil, entryKey: "BornYear", displayName: "Year Born", required : false, choiceGeneratorModel: SPYearsGeneratorModel()));
        // gender
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:nil, entryKey: "Gender", displayName: "Gender", required : false, choiceGeneratorModel: SPGenderGeneratorModel()));
        // country
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:nil, entryKey: "HomeCountry", displayName: "Home Country", required : false, choiceGeneratorModel: SPCountryGeneratorModel()));
        // languages
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:nil, entryKey: "NativeLanguage", displayName: "Native Language", required : false, choiceGeneratorModel: SPLanguageGeneratorModel()));
        // email
        self.profileInfo.append(SPProfileEntryModel(type: .TextEmail, value:nil, entryKey: "Email", displayName: "Email", required : true, choiceGeneratorModel: nil));
        // password
        self.profileInfo.append(SPProfileEntryModel(type: .TextPassword, value:nil, entryKey: "Password", displayName: "Password", required : true, choiceGeneratorModel: nil));
        self.profileInfo.append(SPProfileEntryModel(type: .TextPassword, value:nil, entryKey: "Password", displayName: "Confirm Password", required : true, choiceGeneratorModel: nil));
        // profile picture
        self.profileInfo.append(SPProfileEntryModel(type: .Image, value:nil, entryKey: "ProfilePicture", displayName: "Profile Picture", required : false, choiceGeneratorModel: nil));
        // submit button
        self.profileInfo.append(SPProfileEntryModel(type: .Submit, value:nil, entryKey: "Submit", displayName: "Create Account", required : false, choiceGeneratorModel: nil));
    }
    
    
    
    func checkSamePassword() -> Bool {
        var passwordsArray : [SPProfileEntryModel] = [];
        for profileEntry in self.profileInfo {
            if profileEntry.entryKey == "Password" {
                passwordsArray.append(profileEntry);
            }
        }
        if passwordsArray.count < 2 {
            return true;
        }
        if let password = passwordsArray[0].value as? String {
            if let passwordConfirm = passwordsArray[1].value as? String {
                if password == passwordConfirm {
                    return true;
                }
            }
        }
        return false;
    }
    func getEmail() -> String {
        for profileModel in self.profileInfo {
            if profileModel.entryKey == "Email" {
                if let email = profileModel.value as? String {
                    return email;
                }
            }
        }
        return "";
    }
}
