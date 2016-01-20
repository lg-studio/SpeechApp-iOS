//
//  AudioPromptModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class AudioPromptModel: BaseBoxModel {
    var headerText : String?;
    var audioURL : String?;
    
    // variables used for the audio player
    var elapsedPercent : Float = 0.0;
    var elapsedString : String?;
    var itemDuration : String?;
    var audioPromptIndex : Int = 0;
    
    weak var audioPromptDelegate: SPChatBaseAudioPromptViewCellPlayerProtocol?;
    var audioPlayer : BABAudioPlayer?;
    var audioItem : BABAudioItem?;
    
    init(chatModel : NSDictionary, itemId : Int, nodeId : Int) {
        super.init(chatModel: chatModel, nodeId : nodeId);
        
        self.itemId = itemId;
        self.headerText = "";
        self.audioURL = "";
        
        if let headerText = chatModel.objectForKey("HeaderText") as? String {
            self.headerText = headerText;
        }
        
        if let audioURL = chatModel.objectForKey("AudioUrl") as? String {
            self.audioURL = audioURL;
        }
        self.elapsedPercent = 0.0;
        self.elapsedString = "0:00";
        self.itemDuration = "";
        
        self.boxModelType = BoxModelTypes.AudioPrompt.rawValue;
        
        self.initOutputFulfilled();
    }
    
    init(userName : String, userImageURL : String, personalMesage : Bool, headerText : String, audioURL : String) {
        
        super.init(userName: userName, userImageURL: userImageURL, personalMesage: personalMesage);
        self.headerText = headerText;
        self.audioURL = audioURL;
        self.elapsedPercent = 0.0;
        self.elapsedString = "0:00";
        self.itemDuration = "";
        self.boxModelType = BoxModelTypes.AudioPrompt.rawValue;
        
        self.initOutputFulfilled();
    }
    
    private func initOutputFulfilled() {
        // the user's audio recordings are fulfilled by default
        if self.personalMesage == true {
            self.outputFulfilled = true;
        }
        // the audios from the server are fulfilled only when they are Played
        else {
            self.outputFulfilled = false;
        }
    }
    
    // function called from the output boxes when an item reached the Playing state
    func hasFulfilled() {
        lock(self) {
            // if already fulfilled then ignore
            if self.outputFulfilled == true {
                return;
            }
            // signal the fulfillment of one audio prompt to the delegate
            self.outputFulfilled = true;
            self.outputFulfilledDelegate?.didFulfillAudioPrompt();
        }
    }
    
    func getAudioURL() -> NSURL {
        if(self.personalMesage == true) {
            // personal message can be local or from server (in RebuildTask)
            let fullLocalPath = SPUtils.getFullPathFromNSDocuments(self.audioURL!);
            if NSFileManager.defaultManager().fileExistsAtPath(fullLocalPath) {
                return NSURL(fileURLWithPath: fullLocalPath)!;
            }
            else {
                return NSURL(string: self.audioURL!)!;
            }
        }
        else {
            return NSURL(string: self.audioURL!)!;
        }
    }
}