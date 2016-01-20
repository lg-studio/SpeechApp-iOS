//
//  MultipleTextChoiceModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SingleTextChoiceModel: SingleChoiceModel, Printable {
    var choiceText : String;
    override var description : String {
        return "SingleChoiceModel [\(self.choiceText)]";
    };
    
    override init(choiceDict : NSDictionary) {
        self.choiceText = "";
        if let choiceText = choiceDict.objectForKey("Text") as? String {
            self.choiceText = choiceText;
        }
        
        super.init(choiceDict : choiceDict);
    }
    
    override func getResponseValue() -> String {
        return self.choiceText;
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        self.choiceText = "";
        if let choiceText = aDecoder.decodeObjectForKey("choiceText") as? String {
            self.choiceText = choiceText;
        }
        super.init(coder: aDecoder);
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.choiceText, forKey: "choiceText");
        super.encodeWithCoder(aCoder);
    }
}