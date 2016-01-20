//
//  MultipleImageChoiceModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SingleImageChoiceModel: SingleChoiceModel {
    var choiceImageURL : String;
    override var description : String {
        return "SingleImageChoiceModel [\(self.choiceImageURL)]";
    };
    
    override init(choiceDict : NSDictionary) {
        self.choiceImageURL = "";
        if let choiceImageURL = choiceDict.objectForKey("PictureUrl") as? String {
            self.choiceImageURL = choiceImageURL;
        }
        
        super.init(choiceDict : choiceDict);
    }
    
    override func getResponseValue() -> String {
        return self.choiceImageURL;
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        self.choiceImageURL = "";
        if let choiceImageURL = aDecoder.decodeObjectForKey("choiceImageURL") as? String {
            self.choiceImageURL = choiceImageURL;
        }
        super.init(coder: aDecoder);
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.choiceImageURL, forKey: "choiceImageURL");
        super.encodeWithCoder(aCoder);
    }
}