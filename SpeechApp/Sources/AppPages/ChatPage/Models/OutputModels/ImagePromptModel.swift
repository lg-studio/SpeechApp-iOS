//
//  ImagePromptModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 06/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class ImagePromptModel: BaseBoxModel {
    var textHeader  : String?;
    var imageURL    : String?;
    
    init(chatModel : NSDictionary, itemId : Int, nodeId : Int) {
        super.init(chatModel: chatModel, nodeId : nodeId);
        
        self.itemId = itemId;
        self.textHeader = "";
        if let textHeader = chatModel.objectForKey("TextHeader") as? String {
            self.textHeader = textHeader;
        }

        self.imageURL = "";
        if let imageURL = chatModel.objectForKey("ImageUrl") as? String {
            self.imageURL = imageURL;
        }
        self.boxModelType = BoxModelTypes.ImagePrompt.rawValue;
    }
    
    init(userName : String, userImageURL : String, personalMesage : Bool, textHeader : String, imageURL : String) {
        
        super.init(userName: userName, userImageURL: userImageURL, personalMesage: personalMesage);
        self.textHeader = textHeader;
        self.imageURL = imageURL;
        self.boxModelType = BoxModelTypes.ImagePrompt.rawValue;
    }
}