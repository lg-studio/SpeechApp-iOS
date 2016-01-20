//
//  ProfileBioModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 27/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class ProfileBioModel: NSObject {
    var userName : String?;
    var email : String?;
    var profileImageUrl : String?;
    var firstName : String?;
    var lastName : String?;
    var lastSeenDate : Double?;
    var bornYear : Int?;
    var gender : String?;
    var homeCountry : String?;
    var nativeLanguage : String?;
    var registrationDate : Double?;
    
    var bioArray : [BasicKeyValueContainerModel] = [];
    var inited : Bool;

    
    override init() {
        self.inited = false;
        super.init();
    }
    
    func getProfileBio(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: "ProfileBio", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let profileDict = dataDict.objectForKey("ProfileBio") as? NSDictionary {
                        
                        self?.bioArray = [];
                        
                        if let userName = profileDict.objectForKey("UserName") as? String {
                            self?.userName = userName;
                        }
                        
                        if let profileImageUrl = profileDict.objectForKey("ProfileImageUrl") as? String {
                            self?.profileImageUrl = profileImageUrl;
                        }
                        
                        var name = "";
                        if let firstName = profileDict.objectForKey("FirstName") as? String {
                            self?.firstName = firstName;
                            name = firstName;
                        }
                        
                        if let lastName = profileDict.objectForKey("LastName") as? String {
                            self?.lastName = lastName;
                            name = String(format: "%@ %@", name, lastName);
                        }
                        self?.bioArray.append(BasicKeyValueContainerModel(paramName: "Name", paramValue: name));
                        
                        if let email = profileDict.objectForKey("Email") as? String {
                            self?.email = email;
                            self?.bioArray.append(BasicKeyValueContainerModel(paramName: "Email", paramValue: email));
                        }
                        
                        if let lastSeenDate = profileDict.objectForKey("LastSeenDate") as? Double {
                            self?.lastSeenDate = lastSeenDate;
                        }
                        
                        if let bornYear = profileDict.objectForKey("BornYear") as? Int {
                            self?.bornYear = bornYear;
                            self?.bioArray.append(BasicKeyValueContainerModel(paramName: "Year Born", paramValue: String(format:"%d", bornYear)));
                        }
                        
                        if let gender = profileDict.objectForKey("Gender") as? String {
                            self?.gender = gender;
                            self?.bioArray.append(BasicKeyValueContainerModel(paramName: "Gender", paramValue: gender));
                        }
                        
                        if let homeCountry = profileDict.objectForKey("HomeCountry") as? String {
                            self?.homeCountry = homeCountry;
                            self?.bioArray.append(BasicKeyValueContainerModel(paramName: "Home Country", paramValue: homeCountry));
                        }
                        
                        if let nativeLanguage = profileDict.objectForKey("NativeLanguage") as? String {
                            self?.nativeLanguage = nativeLanguage;
                            self?.bioArray.append(BasicKeyValueContainerModel(paramName: "Native Language", paramValue: nativeLanguage));
                        }
                        
                        if let registrationDate = profileDict.objectForKey("RegistrationDate") as? Double {
                            self?.registrationDate = registrationDate;
                        }
                        
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }
    
    func getFullName() -> String {
        return SPUtils.concatenateStrings(self.firstName, string2: self.lastName);
    }
    
    func getLastSeenDateString() -> String {
        if self.lastSeenDate == nil {
            let timestamp : Double = NSDate().timeIntervalSince1970 * 1000.0;
            return self.getTimestampString(timestamp);
        }
        return self.getTimestampString(self.lastSeenDate!);
    }

}
