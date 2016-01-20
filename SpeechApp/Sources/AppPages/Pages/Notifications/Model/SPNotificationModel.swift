//
//  SPNotificationModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 18/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPNotificationModelTypes : String {
    case PLAIN_MESSAGE      =   "PlainMessage"
    case RECEIVED_FEEDBACK  =   "ReceivedFeedback"
    case SENT_FEEDBACK      =   "SentFeedback"
}



class SPNotificationModel: NSObject {
    var notificationType : SPNotificationModelTypes;
    var notificationId : String;
    var message : String;
    var readTimestamp : Double?;
    var taskModel : SPNotificationTaskModel?;
    var estimatedHeight : CGFloat?;
    
    init(inputDict : NSDictionary) {
        self.notificationType = SPNotificationModelTypes.PLAIN_MESSAGE;
        if let notificationType = inputDict.objectForKey("Type") as? String {
            switch notificationType {
            case SPNotificationModelTypes.RECEIVED_FEEDBACK.rawValue:
                self.notificationType = .RECEIVED_FEEDBACK;
                break;
            case SPNotificationModelTypes.SENT_FEEDBACK.rawValue:
                self.notificationType = .SENT_FEEDBACK;
                break;
            default:
                break;
            }
        }
        
        self.notificationId = "";
        if let notificationId = inputDict.objectForKey("Id") as? String {
            self.notificationId = notificationId;
        }
        
        self.message = "";
        if let message = inputDict.objectForKey("Message") as? String {
            self.message = message;
        }
        
        if let readTimestamp = inputDict.objectForKey("ReadTimestamp") as? Double {
            self.readTimestamp = readTimestamp;
        }
        
        if let propertiesDict = inputDict.objectForKey("Properties") as? NSDictionary {
            let taskModel = SPNotificationTaskModel(inputDict : propertiesDict);
            if taskModel.valid {
                self.taskModel = taskModel;
            }
        }
        
        super.init();
    }
    
    func markAsRead() {
        readTimestamp = NSDate().timeIntervalSince1970 * 1000.0;
        let parameters = [
            "Id" : self.notificationId
        ];
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.post("ReadNotification", parameters: parameters,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
            },
            onSuccess: {[weak self] (data : NSObject) in
            }
        );
    }
}