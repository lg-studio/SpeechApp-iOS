//
//  SPProfileTaskContainerModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileTaskContainerModel: NSObject {
    var tasksArray : [SPProfileTaskGradeModel] = [];
    var inited : Bool;
    
    
    override init() {
        self.inited = false;
        super.init();
    }
    
    func getProfileTasks(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: "ProfileTasks", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let profileTasksArray = dataDict.objectForKey("ProfileTasks") as? NSArray {
                        self?.tasksArray = [];
                        for profileTasksData in profileTasksArray {
                            if let taskDict = profileTasksData as? NSDictionary {
                                self?.tasksArray.append(SPProfileTaskGradeModel(inputDict : taskDict));
                            }
                        }
                        
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }
}
