//
//  FinishGameModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 03/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class FinishGameModel : BaseInputModel {
    override init() {
        super.init();
        self.inputType = InputModelTypes.FinishGameInput.rawValue;
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder);
    }
}