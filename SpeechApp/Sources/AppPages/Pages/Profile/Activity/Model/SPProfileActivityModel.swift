//
//  SPProfileActivityModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 14/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileActivityModel: NSObject {
    var taskId : String?;
    var taskName : String?;
    var feedback : Double?;
    var createdTimestamp : Double?;
    
    var valid = false;
    var estimatedHeight : CGFloat = 50.0;
    
    init(inputDict : NSDictionary) {
        super.init();
        
        if let taskId = inputDict.objectForKey("TaskId") as? String {
            self.taskId = taskId;
            self.valid = true;
        }
        
        if let taskName = inputDict.objectForKey("TaskName") as? String {
            self.taskName = taskName;
        }
        
        if let feedback = inputDict.objectForKey("Feedback") as? Double {
            self.feedback = feedback;
        }
        
        if let createdTimestamp = inputDict.objectForKey("CreatedTimestamp") as? Double {
            self.createdTimestamp = createdTimestamp;
        }
    }
    
    func getTaskName() -> String {
        if self.taskName == nil {
            return "-";
        }
        return self.taskName!;
    }
    func getFeedbackScore() -> String {
        if self.feedback == nil {
            return "-";
        }
        return self.computePercentageString(self.feedback!);
    }
    func getCreatedAt() -> String {
        if self.createdTimestamp == nil {
            return "-";
        }
        return self.getTimestampString(self.createdTimestamp!);
    }
    
    static func createActivitiesArrayFromDictionary(dataDict : NSDictionary) -> [SPProfileActivityModel] {
        var activities : [SPProfileActivityModel] = []
        
        if let activitiesArray = dataDict.objectForKey("ProfileActivities") as? NSArray {
            for activityObject in activitiesArray {
                if let activityDict = activityObject as? NSDictionary {
                    let activity = SPProfileActivityModel(inputDict: activityDict);
                    if activity.valid {
                        activities.append(activity);
                    }
                }
            }
        }
        return activities;
    }
}
