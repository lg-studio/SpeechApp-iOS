//
//  TextPromptModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class TextPromptModel: BaseBoxModel {
    var text : String?;
    
    init(chatModel : NSDictionary, itemId : Int, nodeId : Int) {
        super.init(chatModel: chatModel, nodeId : nodeId);
        
        self.itemId = itemId;
        self.text = "";
        if let text = chatModel.objectForKey("Text") as? String {
            self.text = text;
        }
        self.boxModelType = BoxModelTypes.TextPrompt.rawValue;
    }
    
    init(userName : String, userImageURL : String, personalMesage : Bool, text : String) {
        
        super.init(userName: userName, userImageURL: userImageURL, personalMesage: personalMesage);
        self.text = text;
        self.boxModelType = BoxModelTypes.TextPrompt.rawValue;
    }
}