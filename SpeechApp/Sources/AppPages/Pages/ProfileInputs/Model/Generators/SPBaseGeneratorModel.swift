//
//  SPBaseGeneratorModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseGeneratorModel: NSObject {
    var values : [AnyObject] = [];
    var defaultValue : AnyObject?;
    
    func getValueAtIndex(index : Int) -> String {
        let value : AnyObject = self.values[index];
        return SPUtils.convertAnyObjectToString(value);
    }
    
    
}
