//
//  SPChatFactoryOutputGeneratorExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import Foundation
import UIKit

/*
** Extension used to generate table cells automatically 
** after the input views finish their tasks
*/

extension SPChatFactory {
    // function to add AudioPromptModel in the current output models
    func generateAudioPromptModel(audioURL : String) {
        lock(self) {
            var audioPromptModel = AudioPromptModel(userName: self.userDetailsModel.getName(), userImageURL: self.userDetailsModel.imageURL!, personalMesage: true, headerText: "", audioURL: audioURL);
            self.chatModel.currentOutputModelsConfig.append(audioPromptModel);
        }
    }
    
    // function to add TextPromptModel after a rating
    func generateTextPromptModelAfterRating(ratingModel : RatingInputModel) {
        lock(self) {
            var text : String;
            
            if(ratingModel.metrics?.count > 1) {
                text = String(format: "The ratings for %@ are:", ratingModel.username!);
            }
            else {
                text = String(format: "The rating for %@ is:", ratingModel.username!);
            }
            
            for i in 0..<ratingModel.metrics!.count {
                let metric = ratingModel.metrics![i];
                text = String(format: "%@ %d%% in %@", text, Int(metric.rating! * 100), metric.category!);
                if i < ratingModel.metrics!.count - 1 {
                    text = String(format : "%@,", text);
                }
            }
            var textPromptModel = TextPromptModel(userName: self.userDetailsModel.getName(), userImageURL: self.userDetailsModel.imageURL!, personalMesage: true, text: text);
            self.chatModel.currentOutputModelsConfig.append(textPromptModel);
        }
    }
    
    // function called after multiple choice answer
    func didAddMultipleChoiceResponse(multipleChoiceModel : MultipleChoiceModel) {
        lock(self) {
            var userPromptModel : BaseBoxModel;
            switch(multipleChoiceModel.inputType!) {
            case InputModelTypes.MultipleChoicePictureInput.rawValue:
                userPromptModel = ImagePromptModel(userName: self.userDetailsModel.getName(), userImageURL: self.userDetailsModel.imageURL!, personalMesage: true, textHeader: "", imageURL: multipleChoiceModel.getSelectedAnswerValue());
                break;
            case InputModelTypes.MultipleChoiceTextInput.rawValue:
                userPromptModel = TextPromptModel(userName: self.userDetailsModel.getName(), userImageURL: self.userDetailsModel.imageURL!, personalMesage: true, text: multipleChoiceModel.getSelectedAnswerValue());
                break;
            default:
                return;
            }
            self.chatModel.currentOutputModelsConfig.append(userPromptModel);
            self.chatDelegate?.reloadChatTableView();
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] in
                var robotTextPromptModel = TextPromptModel(userName: "Catalin Dobre", userImageURL: "http://46.4.214.252:8080/dobre.png", personalMesage: false, text: multipleChoiceModel.getSelectedAnswerRobotMessage());
                self?.chatModel.currentOutputModelsConfig.append(robotTextPromptModel);
                self?.chatModel.continueCurrentGame();
            };
            
            
        }
    }
}
