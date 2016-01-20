//
//  SPNotificationTaskModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 18/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPNotificationTaskModel: NSObject {
    var taskId : String;
    var nodeId : Int?;
    
    var valid : Bool;
    
    init(inputDict : NSDictionary) {
        self.valid = false;
        
        self.taskId = "";
        if let taskId = inputDict.objectForKey("TaskId") as? String {
            self.taskId = taskId;
            self.valid = true;
        }
        if let nodeId = inputDict.objectForKey("NodeId") as? Int {
            self.nodeId = nodeId;
        }
        
        super.init();
    }
}
