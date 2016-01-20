//
//  SPTopicProperties.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPTopicPropertiesKeys : String {
    case AverageScore = "AverageScore"
    case MinutesSpent = "MinutesSpent"
}

class SPTopicPropertiesModel: NSObject {
    
    // the item's type
    var averageScore : Double;
    var minutesSpent : Int;
    
    init(inputDict : NSDictionary) {
        self.averageScore = 0;
        if let averageScore = inputDict.objectForKey(SPTopicPropertiesKeys.AverageScore.rawValue) as? Double {
            self.averageScore = averageScore;
        }
        
        self.minutesSpent = 0;
        if let minutesSpent = inputDict.objectForKey(SPTopicPropertiesKeys.MinutesSpent.rawValue) as? Int {
            self.minutesSpent = minutesSpent;
        }

        super.init();
    }
    
    func getAverageScoreLabel() -> String {
        return String(format: "%d", Int(self.averageScore * 100));
    }
    
    func getMinutesSpentLabel() -> String {
        return SPUtils.formatMinutes(self.minutesSpent);
    }
    
}
