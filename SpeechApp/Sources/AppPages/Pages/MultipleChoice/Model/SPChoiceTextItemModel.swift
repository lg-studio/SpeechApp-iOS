//
//  SPChoiceTextItemModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit


class SPChoiceTextItemModel: SPChoiceBaseItemModel {
    var text : String;
    
    init(inputDict : NSDictionary) {
        self.text = "";

        if let text = inputDict.objectForKey(SPChoiceItemKeys.Text.rawValue) as? String {
            self.text = text;
        }
        
        super.init();
    }
    override init() {
        self.text = "";
        super.init();
    }
}