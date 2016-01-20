//
//  MultipleChoiceModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class MultipleChoiceModel: BaseInputModel {
    var linkedEntityId : String?;
    var choices : [SingleChoiceModel]?;
    var successMessage : String?;
    var insuccessMessage : String?;
    
    var selectedAnswerIndex : Int?;
    
    override var description : String {
        return "MultipleChoiceModel [\(self.choices), \(self.selectedAnswerIndex)]";
    };
    
    init(inputModel : NSDictionary, modelType : String, itemId : Int, nodeId : Int) {
        super.init(inputModel: inputModel, itemId : itemId, nodeId : nodeId);
        
        self.inputType = modelType;
        self.choices = [];
        self.selectedAnswerIndex = -1;
        
        if let choicesArray = inputModel.objectForKey("Options") as? NSArray {
            for choice in choicesArray {
                if let choiceDict = choice as? NSDictionary {
                    switch self.inputType! {
                    case InputModelTypes.MultipleChoicePictureInput.rawValue:
                        var pictureChoiceEntry = SingleImageChoiceModel(choiceDict: choiceDict);
                        self.choices?.append(pictureChoiceEntry);
                        break;
                    case InputModelTypes.MultipleChoiceTextInput.rawValue:
                        var textChoiceEntry = SingleTextChoiceModel(choiceDict: choiceDict);
                        self.choices?.append(textChoiceEntry);
                        break;
                    default:
                        break;
                    }
                }
            }
        }
        self.successMessage = "";
        if let successMessage = inputModel.objectForKey("SuccessMessage") as? String {
            self.successMessage = successMessage;
        }
        
        self.insuccessMessage = "";
        if let insuccessMessage = inputModel.objectForKey("InsuccessMessage") as? String {
            self.insuccessMessage = insuccessMessage;
        }
        
        self.linkedEntityId = "";
        if let linkedEntityId = inputModel.objectForKey("LinkedEntityId") as? String {
            self.linkedEntityId = linkedEntityId;
        }
    }
    
    func isAnswerSelected() -> Bool {
        return self.selectedAnswerIndex>=0;
    }
    func selectAnswer(answerIndex : Int) {
        if(answerIndex>=0 && answerIndex<=3) {
            self.selectedAnswerIndex = answerIndex;
        }
    }
    
    func getSelectedAnswerValue() -> String {
        if !isAnswerSelected() {
            return "";
        }
        let choiceModel = self.choices![self.selectedAnswerIndex!];
        return choiceModel.getResponseValue();
    }
    
    func getSelectedAnswerRobotMessage() -> String {
        if isCorrect() {
            return self.successMessage!;
        }
        return self.insuccessMessage!;
    }
    
    func isCorrect() -> Bool {
        if !isAnswerSelected() {
            return false;
        }
        let choiceModel = self.choices![self.selectedAnswerIndex!];
        if(choiceModel.choiceValue == 1) {
            return true;
        }
        return false
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        if let linkedEntityId = aDecoder.decodeObjectForKey("linkedEntityId") as? String {
            self.linkedEntityId = linkedEntityId;
        }
        self.choices = [];
        if let choices = aDecoder.decodeObjectForKey("choices") as? [SingleChoiceModel] {
            self.choices = choices;
        }
        if let successMessage = aDecoder.decodeObjectForKey("successMessage") as? String {
            self.successMessage = successMessage;
        }
        if let insuccessMessage = aDecoder.decodeObjectForKey("insuccessMessage") as? String {
            self.insuccessMessage = insuccessMessage;
        }
        self.selectedAnswerIndex = aDecoder.decodeIntegerForKey("selectedAnswerIndex");
        super.init(coder: aDecoder);
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.linkedEntityId!, forKey: "linkedEntityId");
        aCoder.encodeObject(self.choices, forKey: "choices");
        aCoder.encodeObject(self.successMessage, forKey: "successMessage");
        aCoder.encodeObject(self.insuccessMessage, forKey: "insuccessMessage");
        aCoder.encodeInteger(self.selectedAnswerIndex!, forKey : "selectedAnswerIndex");
        super.encodeWithCoder(aCoder);
    }
}
