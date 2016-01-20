//
//  SingleChoiceModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SingleChoiceModel: NSObject, NSCoding {
    var choiceValue : Int;
    
    init(choiceDict : NSDictionary) {
        self.choiceValue = 0;
        if let choiceValue = choiceDict.objectForKey("Value") as? Int {
            self.choiceValue = choiceValue;
        }
        
        super.init();
    }
    
    func getResponseValue() -> String {
        return "";
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        self.choiceValue = aDecoder.decodeIntegerForKey("choiceValue");
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.choiceValue, forKey: "choiceValue");
    }
}
