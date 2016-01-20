//
//  SPChatFactoryInputViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 30/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import Foundation
import UIKit

protocol SPChatFactoryOutputFulfilledDelegate : class {
    func didFulfillAudioPrompt();
}

extension SPChatFactory : SPChatFactoryOutputFulfilledDelegate {
    
    func getInputViewController() -> SPChatBaseInputViewController {
        if(self.currentInputVC != nil) {
            self.currentInputVC!.removeSelfVCFromParentViewController();
        }
        
        
        let inputModel : BaseInputModel = chatModel.currentInputModel;
        
        var chatInputVC : SPChatBaseInputViewController;
        
        switch inputModel.inputType! {
        case InputModelTypes.RecordingInput.rawValue:
            chatInputVC = SPChatRecordingInputViewController(recordingModel: inputModel as! RecordingInputModel);
            break;
        case InputModelTypes.FinishGameInput.rawValue:
            chatInputVC = SPChatFinishGameInputViewController();
            break;
        case InputModelTypes.RatingInput.rawValue:
            chatInputVC = SPChatRatingInputViewController(ratingModel: inputModel as! RatingInputModel);
            break;
        case InputModelTypes.MultipleChoiceTextInput.rawValue:
            chatInputVC = SPChatTextMultipleChoiceInputViewController(multipleChoiceModel: inputModel as! MultipleChoiceModel);
            break;
        case InputModelTypes.MultipleChoicePictureInput.rawValue:
            chatInputVC = SPChatImageMultipleChoiceInputViewController(multipleChoiceModel: inputModel as! MultipleChoiceModel);
            break;
        default:
            chatInputVC = SPChatBaseInputViewController();
            break;
        }
        self.currentInputVC = chatInputVC;

        if self.chatModel.outputsFulfilled() {
            self.currentInputVC?.fulfilledStatus = SPChatBaseInputStatus.FULFILLED;
        }

        return self.currentInputVC!;
    }
    
    func addUserInput(inputModel : BaseInputModel) {
        self.chatModel.userInputContainerModel.addUserInput(inputModel);
    }
    
    // MARK : SPChatFactoryOutputFulfilledDelegate implementation
    func didFulfillAudioPrompt() {
        // if all the output audio prompts have been played
        // then signal the FULFILLED state to the input view controller
        if self.chatModel.outputsFulfilled() {
            self.currentInputVC?.setState(SPChatBaseInputStatus.FULFILLED);
        }
    }
    
}