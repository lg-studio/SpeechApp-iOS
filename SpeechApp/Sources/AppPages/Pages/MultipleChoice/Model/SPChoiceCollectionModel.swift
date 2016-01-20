//
//  SPChoiceCollectionModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChoiceCollectionModel: NSObject {
    var taskTemplateId  : String;
    var options         : [SPChoiceItemModel];
    var displayText     : String;
    var inited          : Bool;
    
    init(taskTemplateId : String) {
        self.options = [];
        self.taskTemplateId = taskTemplateId;
        self.displayText = "";
        self.inited = false;
        super.init();
    }
    
    func getMultipleChoiceOptions(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        
        httpUtilities.getAnimated(view, methodName: String(format : "MultipleChoiceOptions/%@", taskTemplateId), parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let mCOptionsDict = dataDict.objectForKey("MultipleChoiceOptions") as? NSDictionary {
                        self?.displayText = "";
                        if let displayText = mCOptionsDict.objectForKey("DisplayText") as? String {
                            self?.displayText = displayText;
                        }
                        
                        self?.options = [];
                        if let mCOptionsArray = mCOptionsDict.objectForKey("Options") as? NSArray {
                            
                            for mCOptionData in mCOptionsArray {
                                // compute the master options
                                if let mCOptionDict = mCOptionData as? NSDictionary {
                                    self?.options.append(SPChoiceItemModel(inputDict: mCOptionDict));
                                }
                            }
                        }
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }
    
}
