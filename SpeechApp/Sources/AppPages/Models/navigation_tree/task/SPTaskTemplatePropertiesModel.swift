//
//  SPTaskTemplateProperties.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPTaskTemplatePropertiesKeys : String {
    case Retries        = "Retries"
    case AverageRating  = "AverageRating"
}

class SPTaskTemplatePropertiesModel: NSObject {
    // the item's type
    var retries : Int;
    var averageRating : Double;
    
    init(inputDict : NSDictionary) {
        self.retries = 0;
        if let retries = inputDict.objectForKey(SPTaskTemplatePropertiesKeys.Retries.rawValue) as? Int {
            self.retries = retries;
        }
        
        self.averageRating = 0;
        if let averageRating = inputDict.objectForKey(SPTaskTemplatePropertiesKeys.AverageRating.rawValue) as? Double {
            self.averageRating = averageRating;
        }
        
        super.init();
    }
    
    func getRetriesLabel() -> String {
        return String(format: "%d", self.retries);
    }
    
    func getAverageRatingLabel() -> String {
        return String(format: "%d", Int(self.averageRating * 100));
    }
}
