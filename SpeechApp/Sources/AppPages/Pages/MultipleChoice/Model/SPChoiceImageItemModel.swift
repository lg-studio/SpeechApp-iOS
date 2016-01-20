//
//  SPChoiceImageItemModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChoiceImageItemModel: SPChoiceBaseItemModel {
    var imageUrl : String;
    
    init(inputDict : NSDictionary) {
        self.imageUrl = "";
        
        if let imageUrl = inputDict.objectForKey(SPChoiceItemKeys.ImageUrl.rawValue) as? String {
            self.imageUrl = imageUrl;
        }
        
        super.init();
    }
    override init() {
        self.imageUrl = "";
        super.init();
    }
}
