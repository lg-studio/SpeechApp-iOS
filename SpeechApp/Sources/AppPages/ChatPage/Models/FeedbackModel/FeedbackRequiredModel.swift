//
//  FeedbackRequiredModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 03/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum FeedbackRequiredTypes : String {
    case FeedbackRequired   =   "FeedbackRequired"
};

class FeedbackRequiredModel: NSObject {
    // the input's type
    var feedbackRequiredType : String?;
    var questionId : Int?;
    var uIObjectId : Int?;
    var itemId : Int?;
    
    init(feedbackRequiredModel : NSDictionary, itemId : Int) {
        super.init();
        self.itemId = itemId;
        self.questionId = 0;
        if let questionId = feedbackRequiredModel.objectForKey("QuestionId") as? Int {
            self.questionId = questionId;
        }
        self.feedbackRequiredType = FeedbackRequiredTypes.FeedbackRequired.rawValue;
    }
    override init() {
        super.init();
    }
    
    // simulate obtaining the JSON from server
    func getFeedbackPageObjects(taskId : String, onCompletion : ((NSArray, Int) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.get(String(format: "NodeStructure/%@/%d", taskId, self.itemId!), parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                if let uIObjectId = self?.uIObjectId {
                    onCompletion([], uIObjectId);
                }
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let uIObjectId = self?.uIObjectId {
                    if let dataDict = data as? NSDictionary {
                        if let dataArray = dataDict["Items"] as? NSArray {
                            onCompletion(dataArray, uIObjectId);
                        }
                    }
                }
                
            }
        );
    }
}