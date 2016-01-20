//
//  SPTopic.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPTopicKeys : String {
    case Id            = "Id"
    case Name          = "Name"
    case IconUrl       = "IconUrl"
    case Properties    = "Properties"
    case TaskTemplates = "TaskTemplates"
}

class SPTopicModel: NSObject {
    
    
    // the item's type
    var topicId         : String;
    var name            : String;
    var iconUrl         : String;
    var properties      : SPTopicPropertiesModel?;
    var taskTemplates   : [SPTaskTemplateModel];
    
    init(inputDict : NSDictionary) {
        self.topicId = "";
        if let topicId = inputDict.objectForKey(SPTopicKeys.Id.rawValue) as? String {
            self.topicId = topicId;
        }
        
        self.name = "";
        if let name = inputDict.objectForKey(SPTopicKeys.Name.rawValue) as? String {
            self.name = name;
        }
        
        self.iconUrl = "";
        if let iconUrl = inputDict.objectForKey(SPTopicKeys.IconUrl.rawValue) as? String {
            self.iconUrl = iconUrl;
        }
        
        if let propertiesDict = inputDict.objectForKey(SPTopicKeys.Properties.rawValue) as? NSDictionary {
            self.properties = SPTopicPropertiesModel(inputDict: propertiesDict);
        }
        
        self.taskTemplates = [];
        if let taskTemplatesArray = inputDict.objectForKey(SPTopicKeys.TaskTemplates.rawValue) as? NSArray {
            for taskTemplateObject in taskTemplatesArray {
                if let taskTemplateDict = taskTemplateObject as? NSDictionary {
                    self.taskTemplates.append(SPTaskTemplateModel(inputDict: taskTemplateDict));
                }
            }
        }
        
        super.init();
    }
    
    func hasSingleTask() -> Bool {
        return self.taskTemplates.count == 1;
    }
    
    func getTaskNumbers() -> Int {
        return self.taskTemplates.count;
    }
    
    func getFirstTask() -> SPTaskTemplateModel {
        return self.taskTemplates[0];
    }
}
