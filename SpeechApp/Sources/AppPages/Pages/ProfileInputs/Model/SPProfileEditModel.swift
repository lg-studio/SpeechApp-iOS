//
//  SPProfileEditModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileEditModel: SPBaseEntryContainerModel {
    var profileBio : ProfileBioModel;
    
    init(profileBio : ProfileBioModel) {
        self.profileBio = profileBio;
        super.init();
        self.generateProfileInfo();
    }
    
    
    private func generateProfileInfo() {
        self.profileInfo.append(SPProfileEntryModel(type: .TextName, value:self.profileBio.firstName, entryKey: "FirstName", displayName: "First Name", required : true, choiceGeneratorModel: nil));
        self.profileInfo.append(SPProfileEntryModel(type: .TextName, value:self.profileBio.lastName, entryKey: "LastName", displayName: "Last Name", required : true, choiceGeneratorModel: nil));
        // year born
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:self.profileBio.bornYear, entryKey: "BornYear", displayName: "Year Born", required : false, choiceGeneratorModel: SPYearsGeneratorModel()));
        // gender
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:self.profileBio.gender, entryKey: "Gender", displayName: "Gender", required : false, choiceGeneratorModel: SPGenderGeneratorModel()));
        // country
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:self.profileBio.homeCountry, entryKey: "HomeCountry", displayName: "Home Country", required : false, choiceGeneratorModel: SPCountryGeneratorModel()));
        // languages
        self.profileInfo.append(SPProfileEntryModel(type: .Choice, value:self.profileBio.nativeLanguage, entryKey: "NativeLanguage", displayName: "Native Language", required : false, choiceGeneratorModel: SPLanguageGeneratorModel()));
        // email
        //self.profileInfo.append(SPProfileEntryModel(type: .TextEmail, value:self.profileBio.email, entryKey: "Email", displayName: "Email", required : true, choiceGeneratorModel: nil));
        
        // profile picture
        self.profileInfo.append(SPProfileEntryModel(type: .Image, value:self.profileBio.profileImageUrl, entryKey: "ProfilePicture", displayName: "Profile Picture", required : false, choiceGeneratorModel: nil));
        // submit button
        self.profileInfo.append(SPProfileEntryModel(type: .Submit, value:nil, entryKey: "Submit", displayName: "Update Account", required : false, choiceGeneratorModel: nil));
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

}
