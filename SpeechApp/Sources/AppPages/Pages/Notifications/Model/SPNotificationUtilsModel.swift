//
//  SPNotificationUtilsModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 18/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPNotificationUtilsModel: NSObject {
    var currentNotificationType : SPNotificationModelTypes?;
    
    func createNotificationsArrayFromDictionary(dataDict : NSDictionary) -> [SPNotificationModel] {
        var notifications : [SPNotificationModel] = [];
        
        if let notificationsArray = dataDict.objectForKey("Notifications") as? NSArray {
            for notificationData in notificationsArray {
                if let notificationDict = notificationData as? NSDictionary {
                    notifications.append(SPNotificationModel(inputDict: notificationDict));
                }
            }
        }
        
        return notifications;
    }
    
}
