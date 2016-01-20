//
//  SPAppDelegatePushNotificationsExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPAppDelegate {
    func registerForPushNotificationsInApp(application: UIApplication) {
        var types: UIUserNotificationType = UIUserNotificationType.Sound|UIUserNotificationType.Alert | UIUserNotificationType.Badge;
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: types, categories: nil));
        application.registerForRemoteNotifications();
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" );
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String;

        var pushNotifModel = PushNotificationsModel();
        pushNotifModel.setPushNotificationsKeyString(deviceTokenString);
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["message"] as? NSString {
                    //Do stuff
                    self.handleRemoteNotification(message as String);
                }
            } else if let alert = aps["alert"] as? NSString {
                self.handleRemoteNotification(alert as String);
            }
        }
    }
    
    func handleRemoteNotification(notification : String) {
        dispatch_async(dispatch_get_main_queue(), {
            var alert = UIAlertController(title: "Notification", message: notification, preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil);
        })
    }
    
    
}
