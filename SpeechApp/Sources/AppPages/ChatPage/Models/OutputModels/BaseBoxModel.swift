//
//  BaseBoxModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

enum BoxModelTypes : String {
    case TextPrompt     =   "TextPrompt"
    case AudioPrompt    =   "AudioPrompt"
    case TextAreaPrompt =   "TextAreaPrompt"
    case ImagePrompt    =   "ImagePrompt"
};

class BaseBoxModel: NSObject {
    // the node id
    var nodeId : Int?;
    // the id of the item
    var itemId : Int?;
    // the box model's type
    var boxModelType : String?;
    // the user name that will appear under the message
    var userName : String?;
    // the URL of the image from the user's avatar
    var userImageURL : String?;
    // the delay in seconds after the component's rendering
    var delay: Int?;
    
    // a boolean specifying if the message is from me or not
    var personalMesage : Bool = false;
    
    // a boolean indicating that the output was animated in the screen
    var wasAnimated : Bool = false;
    
    // the estimated height of the cell
    var estimatedHeight : CGFloat?;
    
    // if the user has fulfilled (viewed/listened) this output prompt
    // true for all the outputs except for audio outputs
    // it is set true for audio recordings only when the audio has been played
    var outputFulfilled : Bool;
    weak var outputFulfilledDelegate : SPChatFactoryOutputFulfilledDelegate?;
    
    init(chatModel : NSDictionary, nodeId : Int) {
        self.userName = "";
        self.userImageURL = "";
        self.delay = 0;
        self.estimatedHeight = 0;
        self.nodeId = nodeId;

        if let userName = chatModel.objectForKey("Name") as? String {
            self.userName = userName;
        }
        
        if let userImageURL = chatModel.objectForKey("PictureUrl") as? String {
            self.userImageURL = userImageURL;
        }
        
        if let delay = chatModel.objectForKey("Delay") as? Int {
            if(delay > 0) {
                self.delay = delay;
            }
        }
        
        if (chatModel.objectForKey("PersonalMessage") != nil) {
            self.personalMesage = true;
        }
        
        self.outputFulfilled = true;
        super.init();
    }
    
    init(userName : String, userImageURL : String, personalMesage : Bool) {
        self.userName = userName;
        self.userImageURL = userImageURL;
        self.personalMesage = personalMesage;
        self.outputFulfilled = true;
        super.init();
    }
    
}
