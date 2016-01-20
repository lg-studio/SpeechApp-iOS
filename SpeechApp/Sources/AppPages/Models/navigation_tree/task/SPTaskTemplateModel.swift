//
//  SPTaskTemplate.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPTaskTemplateKeys : String {
    case Id         = "Id"
    case TaskType   = "Type"
    case Name       = "Name"
    case Properties = "Properties"
    case IconUrl    = "IconUrl"
}

enum SPTaskTemplateType : String {
    case RegularTask        =   "RegularTask"
    case MultipleChoiceTask =   "MultipleChoiceTask"
    
}

class SPTaskTemplateModel: NSObject {
    // the item's type
    var taskId          : String;
    var taskType        : SPTaskTemplateType;
    var name            : String;
    var properties      : SPTaskTemplatePropertiesModel?;
    var iconUrl : String;
    
    init(inputDict : NSDictionary) {
        self.taskId = "";
        if let taskId = inputDict.objectForKey(SPTaskTemplateKeys.Id.rawValue) as? String {
            self.taskId = taskId;
        }
        
        self.name = "";
        if let name = inputDict.objectForKey(SPTaskTemplateKeys.Name.rawValue) as? String {
            self.name = name;
        }
        
        if let propertiesDict = inputDict.objectForKey(SPTaskTemplateKeys.Properties.rawValue) as? NSDictionary {
            self.properties = SPTaskTemplatePropertiesModel(inputDict: propertiesDict);
        }
        self.iconUrl = "";
        if let iconUrl = inputDict.objectForKey(SPTaskTemplateKeys.IconUrl.rawValue) as? String {
            self.iconUrl = iconUrl;
        }
        
        self.taskType = SPTaskTemplateType.RegularTask;
        if let taskType = inputDict.objectForKey(SPTaskTemplateKeys.TaskType.rawValue) as? String {
            switch taskType {
            case SPTaskTemplateType.MultipleChoiceTask.rawValue:
                self.taskType = SPTaskTemplateType.MultipleChoiceTask;
                break;
            default:
                self.taskType = SPTaskTemplateType.RegularTask;
                break;
            }
        }
        
        super.init();
    }
}
