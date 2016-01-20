//
//  MyUserDetailsModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class UserDetailsModel: NSObject, NSCoding {
    static let DatabaseKey = "UserDetailsModelDBKey";
    
    // the input's type
    var userId : String?;
    var userName : String?;
    var email : String?;
    var firstName : String?;
    var lastName : String?;
    var imageURL : String?;
    var isBasicLogin : Bool?;
    
    init(inputModel : NSDictionary, isBasicLogin : Bool?) {
        super.init();
        self.setDefaultValues();
        
        if isBasicLogin != nil {
            self.isBasicLogin = isBasicLogin!;
        }
        
        if let userId = inputModel.objectForKey("_id") as? String {
            self.userId = userId;
        }
        
        if let userName = inputModel.objectForKey("UserName") as? String {
            self.userName = userName;
        }
        
        if let email = inputModel.objectForKey("Email") as? String {
            self.email = email;
        }
        
        if let firstName = inputModel.objectForKey("FirstName") as? String {
            self.firstName = firstName;
        }
        
        if let lastName = inputModel.objectForKey("LastName") as? String {
            self.lastName = lastName;
        }
        
        if let imageURL = inputModel.objectForKey("ProfileImageUrl") as? String {
            self.imageURL = imageURL;
        }
    }
    override init() {
        super.init();
        self.setDefaultValues();
    }
    
    func getName() -> String {
        return SPUtils.concatenateStrings(self.firstName, string2: self.lastName);
    }
    
    private func setDefaultValues() {
        self.userId         =   "0";
        self.isBasicLogin   =   true;
        self.userName       =   "user.name";
        self.email          =   "user@test.com";
        self.firstName      =   "Speech App";
        self.lastName       =   "User";
        self.imageURL       =   "ProfileImagePlaceholder";
    }
    
    // NSCoding
    required init(coder aDecoder: NSCoder) {
        if let userId = aDecoder.decodeObjectForKey("userId") as? String {
            self.userId = userId;
        }
        if let userName = aDecoder.decodeObjectForKey("userName") as? String {
            self.userName = userName;
        }
        if let email = aDecoder.decodeObjectForKey("email") as? String {
            self.email = email;
        }
        if let firstName = aDecoder.decodeObjectForKey("firstName") as? String {
            self.firstName = firstName;
        }
        if let lastName = aDecoder.decodeObjectForKey("lastName") as? String {
            self.lastName = lastName;
        }
        if let imageURL = aDecoder.decodeObjectForKey("imageURL") as? String {
            self.imageURL = imageURL;
        }
        self.isBasicLogin = aDecoder.decodeBoolForKey("isBasicLogin");
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userId, forKey : "userId");
        aCoder.encodeObject(self.userName, forKey : "userName");
        aCoder.encodeObject(self.email, forKey : "email");
        aCoder.encodeObject(self.firstName, forKey : "firstName");
        aCoder.encodeObject(self.lastName, forKey : "lastName");
        aCoder.encodeObject(self.imageURL, forKey : "imageURL");
        aCoder.encodeBool(self.isBasicLogin!, forKey: "isBasicLogin");
    }
    
    // persis object
    func persist() {
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self), forKey: UserDetailsModel.DatabaseKey);
        NSUserDefaults.standardUserDefaults()
    }
    
    // load object
    static func loadUserDetailsModel() -> UserDetailsModel {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(UserDetailsModel.DatabaseKey) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! UserDetailsModel;
        }
        return UserDetailsModel();
    }
}
