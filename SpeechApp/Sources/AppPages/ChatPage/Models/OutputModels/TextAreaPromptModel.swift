//
//  TextAreaPromptModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 06/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class TextAreaPromptModel: BaseBoxModel {
    var textHeader  : String?;
    var textContent : String?;
    
    init(chatModel : NSDictionary, itemId : Int, nodeId : Int) {
        super.init(chatModel: chatModel, nodeId : nodeId);
        
        self.itemId = itemId;
        self.textHeader = "";
        if let textHeader = chatModel.objectForKey("TextHeader") as? String {
            self.textHeader = textHeader;
        }
        self.textContent = "";
        if let textContent = chatModel.objectForKey("TextContent") as? String {
            self.textContent = textContent;
        }
        
        self.boxModelType = BoxModelTypes.TextAreaPrompt.rawValue;
    }
}