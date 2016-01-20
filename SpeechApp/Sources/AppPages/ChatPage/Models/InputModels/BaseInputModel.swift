//
//  BaseInputModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 01/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum InputModelTypes : String {
    case RecordingInput             =   "RecordingInput"
    case RatingInput                =   "RatingInput"
    case MultipleChoiceTextInput    =   "MultipleChoiceTextInput"
    case MultipleChoicePictureInput =   "MultipleChoicePictureInput"

    case EmptyInput                 =   "EmptyInput"
    case FinishGameInput            =   "FinishGameInput"
};

class BaseInputModel: NSObject, NSCoding {
    // the input's type
    var inputType : String?;
    var itemId : Int;
    var nodeId : Int;
    
    init(inputModel : NSDictionary, itemId : Int, nodeId : Int) {
        self.itemId = itemId;
        self.nodeId = nodeId;
        super.init();
    }
    override init() {
        self.itemId = 0;
        self.nodeId = 0;
        super.init();
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        if let inputType = aDecoder.decodeObjectForKey("inputType") as? String {
            self.inputType = inputType
        }
        self.itemId = aDecoder.decodeIntegerForKey("itemId");
        self.nodeId = aDecoder.decodeIntegerForKey("nodeId");
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.inputType, forKey: "inputType");
        aCoder.encodeInteger(self.itemId, forKey: "itemId");
        aCoder.encodeInteger(self.nodeId, forKey: "nodeId");
    }
}