//
//  SPTaskNavigationTree.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPTaskNavigationTreeKeys : String {
    case TopicList = "TopicList"
}

class SPTaskNavigationTreeModel : NSObject {
    var topics          : [SPTopicModel];
    var inited          : Bool;
    var categoryId      : String;
    var subcategoryId   : String?;
    
    init(categoryId : String, subcategoryId : String?) {
        self.inited = false;
        self.topics = [];
        self.categoryId = categoryId;
        self.subcategoryId = subcategoryId;
        super.init();
    }
    
    func getTaskNavigationTree(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        
        var categoryIdStr = String(format: "%@", self.categoryId);
        var subcategoryIdStr = "";
        if self.subcategoryId != nil {
            subcategoryIdStr = String(format: "%@", self.subcategoryId!);
        }
        
        httpUtilities.getAnimated(view, methodName: String(format : "TaskNavigationTree/%@/%@", categoryIdStr, subcategoryIdStr), parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let topicListArray = dataDict.objectForKey(SPTaskNavigationTreeKeys.TopicList.rawValue) as? NSArray {
                        self?.topics = [];
                        for topicData in topicListArray {
                            if let topicDict = topicData as? NSDictionary {
                                var topicModel = SPTopicModel(inputDict : topicDict);
                                if topicModel.taskTemplates.count > 0 {
                                    self?.topics.append(SPTopicModel(inputDict : topicDict));
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
