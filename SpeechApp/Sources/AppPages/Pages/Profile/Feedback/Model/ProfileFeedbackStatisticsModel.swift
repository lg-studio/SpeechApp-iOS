//
//  ProfileFeedbackStatisticsModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 28/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class ProfileFeedbackStatisticsModel: NSObject {
    var feedbacksGiven : Int;
    var avgFeedbackGiven : Double;
    var feedbacksReceived : Int;
    var avgFeedbackReceived : Double;
    var feedbackScore : Double;
    var feedbackLevel : String;
    
    var statistics : [BasicKeyValueContainerModel];
    var inited : Bool;
    
    override init() {
        self.feedbacksGiven = 0;
        self.avgFeedbackGiven = 0.0;
        self.feedbacksReceived = 0;
        self.avgFeedbackReceived = 0.0;
        self.feedbackScore = 0.0;
        self.feedbackLevel = "";
        self.statistics = [];

        self.inited = false;
        super.init();
    }
    
    func getProfileFeedbackStatistics(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: "ProfileFeedbackStatistics", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let profileDict = dataDict.objectForKey("Statistics") as? NSDictionary {
                        if let feedbacksGiven = profileDict.objectForKey("FeedbacksGiven") as? Int {
                            self?.feedbacksGiven = feedbacksGiven;
                        }
                        
                        if let avgFeedbackGiven = profileDict.objectForKey("AvgFeedbackGiven") as? Double {
                            self?.avgFeedbackGiven = avgFeedbackGiven;
                        }
                        
                        if let feedbacksReceived = profileDict.objectForKey("FeedbacksReceived") as? Int {
                            self?.feedbacksReceived = feedbacksReceived;
                        }
                        
                        if let avgFeedbackReceived = profileDict.objectForKey("AvgFeedbackReceived") as? Double {
                            self?.avgFeedbackReceived = avgFeedbackReceived;
                        }
                        
                        if let feedbackScore = profileDict.objectForKey("FeedbackScore") as? Double {
                            self?.feedbackScore = feedbackScore;
                        }
                        
                        if let feedbackLevel = profileDict.objectForKey("FeedbackLevel") as? String {
                            self?.feedbackLevel = feedbackLevel;
                        }
                        self?.buildStatisticsArray();
                        
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }
    
    func buildStatisticsArray() {
        self.statistics.append(BasicKeyValueContainerModel(paramName: "Feedbacks Given", paramValue: String(self.feedbacksGiven)));
        self.statistics.append(BasicKeyValueContainerModel(paramName: "Average Feedbacks Given", paramValue: self.computePercentageString(self.avgFeedbackGiven)));
        self.statistics.append(BasicKeyValueContainerModel(paramName: "Feedback Received", paramValue: String(self.feedbacksReceived)));
        self.statistics.append(BasicKeyValueContainerModel(paramName: "Average Feedbacks Received", paramValue: self.computePercentageString(self.avgFeedbackReceived)));
        self.statistics.append(BasicKeyValueContainerModel(paramName: "Feedback Score", paramValue: String(format : "%.2f", self.feedbackScore)));
        self.statistics.append(BasicKeyValueContainerModel(paramName: "Feedback Level", paramValue: self.feedbackLevel));
    }
    
    
}
