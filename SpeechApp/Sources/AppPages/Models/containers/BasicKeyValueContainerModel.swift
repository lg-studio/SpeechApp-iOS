//
//  BasicKeyValueContainerModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 28/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class BasicKeyValueContainerModel: NSObject {
    var paramName : String;
    var paramValue : String;
    
    init(paramName : String, paramValue : String) {
        self.paramName = paramName;
        self.paramValue = paramValue;
        super.init();
    }
}
