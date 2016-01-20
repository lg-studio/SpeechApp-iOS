//
//  PushNotificationsModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class PushNotificationsModel: NSObject {
    private static var DatabaseKey : String = "PushNotificationsModel_TokenKey";
    
    var deviceType : String = "iOS";
    var pushNotificationsKey : String?;
    
    
    override init() {
        super.init();
        self.loadFromUserDefaults();
    }
    
    private func loadFromUserDefaults() {
        if let pushNotificationsKey = NSUserDefaults.standardUserDefaults().objectForKey(PushNotificationsModel.DatabaseKey) as? String {
            self.pushNotificationsKey = pushNotificationsKey;
        }
    }
    
    func setPushNotificationsKeyString(deviceToken : String) {
        self.pushNotificationsKey = deviceToken;
        NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: PushNotificationsModel.DatabaseKey);
    }
    
    func sendNotificationKeyToServer() {
        if self.pushNotificationsKey != nil {
            
            let parameters = [
                "MobileNotificationKey" : self.pushNotificationsKey!,
                "MobileType"            : self.deviceType
            ];
            var httpUtilities = THAHttpUtilities.getHttpUtilities();
            httpUtilities.post("UpdateNotificationKey", parameters: parameters,
                onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                },
                onSuccess: {[weak self] (data : NSObject) in
                }
            );
            
        }
        
    }
}
