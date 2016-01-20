//
//  SPChatModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class SPChatModel: NSObject {
    // the type of the template
    var taskTemplateType : SPTaskTemplateType;
    // the id of the template
    var taskTemplateId : String;
    // the id of the task that is created on the server
    var taskId : String;
    // the mode of the chat
    var chatMode : SPChatPageViewControllerMode;
    
    // the id's of the choice options (can be nil if not MC game)
    var optionId : Int?;
    var subOptionId : Int?;
    
    // the inputs of the user
    var userInputContainerModel : SPChatUserInputContainerModel;
    
    // the game configuration array: contains either BaseBoxModels or BaseInputModels
    var gameConfiguration : Array<NSObject>;

    // the current outputs shown in the chat
    var currentOutputModelsConfig : Array<BaseBoxModel>;
    // the current input shown in the chat
    var currentInputModel : BaseInputModel;
    // the next step from the gameConfiguration array
    var nextStepIndex : Int;
    // the link to the chat page 
    weak var chatDelegate: SPChatFactoryProtocol?;
    // the index of the audio prompts
    var audioPromptIndex : Int;
    
    init(view: UIView, var chatMode : SPChatPageViewControllerMode, taskTemplateType : SPTaskTemplateType, taskTemplateId : String, taskId : String, optionId : Int?, subOptionId : Int?) {
        self.chatMode           = chatMode;
        self.taskTemplateType   = taskTemplateType;
        self.taskTemplateId     = taskTemplateId;
        self.taskId             = taskId;
        self.optionId           = optionId;
        self.subOptionId        = subOptionId;
        self.gameConfiguration  = [];
        self.currentOutputModelsConfig      = [];
        self.currentInputModel              = BaseInputModel();
        self.currentInputModel.inputType    = InputModelTypes.EmptyInput.rawValue;
        self.nextStepIndex                  = 0;
        self.userInputContainerModel        = SPChatUserInputContainerModel();
        self.audioPromptIndex               = 0;
        
        super.init();
        self.loadGameConfiguration(view);
    }
    
    /* the loading of the game's configuration */
    func loadGameConfiguration(view: UIView) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: self.getMethodURL(), parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                println("[ERROR] Problem getting chat objects: \(status)");
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let taskId = dataDict.objectForKey("TaskId") as? String {
                        self?.taskId = taskId;
                        self?.userInputContainerModel.taskId = taskId;
                    }
                    if let gameArray = dataDict["Items"] as? NSArray {
                        if let parsedGameArray = self?.parseGameConfiguration(gameArray) {
                            self?.gameConfiguration = parsedGameArray;
                            self?.continueCurrentGame();
                        }
                    }
                }
                
                
            }
        );
    }
    
    /* the parsing of the game's configuration */
    func parseGameConfiguration(gameConfigArray : NSArray) -> Array<NSObject> {
        var outputConfiguration : Array<NSObject> = [];
        for gameConfig in gameConfigArray {
            if let gameConfigDict = gameConfig as? NSDictionary {
                if let gameType = gameConfigDict.objectForKey("Type") as? String {
                    var gameSpecificPropertiesDict : NSDictionary = gameConfigDict["Properties"] as! NSDictionary;
                    var itemId = 0;
                    if let itemIdInt = gameConfigDict["Id"] as? Int {
                        itemId = itemIdInt;
                    }
                    var nodeId = 0;
                    if let nodeIdInt = gameConfigDict["NodeId"] as? Int {
                        nodeId = nodeIdInt;
                    }
                    
                    switch(gameType) {
                    // outputs
                    case BoxModelTypes.TextPrompt.rawValue:
                        var textModel = TextPromptModel(chatModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        outputConfiguration.append(textModel);
                        break;
                    case BoxModelTypes.AudioPrompt.rawValue:
                        var audioModel = AudioPromptModel(chatModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        audioModel.audioPromptIndex = self.audioPromptIndex++;
                        outputConfiguration.append(audioModel);
                        break;
                    case BoxModelTypes.TextAreaPrompt.rawValue:
                        var textAreaModel = TextAreaPromptModel(chatModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        outputConfiguration.append(textAreaModel);
                        break;
                    case BoxModelTypes.ImagePrompt.rawValue:
                        var imagePromptModel = ImagePromptModel(chatModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        outputConfiguration.append(imagePromptModel);
                        break;
                    case BoxModelTypes.AudioPrompt.rawValue:
                        var imagePrompt = ImagePromptModel(chatModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        outputConfiguration.append(imagePrompt);
                        break;

                    // inputs
                    case InputModelTypes.RecordingInput.rawValue:
                        var recordingInputModel = RecordingInputModel(inputModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        outputConfiguration.append(recordingInputModel);
                        break;
                    case InputModelTypes.RatingInput.rawValue:
                        var ratingInputModel = RatingInputModel(inputModel: gameSpecificPropertiesDict, itemId : itemId, nodeId : nodeId);
                        outputConfiguration.append(ratingInputModel);
                        break;
                    case InputModelTypes.MultipleChoicePictureInput.rawValue, InputModelTypes.MultipleChoiceTextInput.rawValue:
                        var multipleChoiceModel = MultipleChoiceModel(inputModel: gameSpecificPropertiesDict, modelType: gameType, itemId : itemId, nodeId : nodeId);
                        // only add models with 4 responses
                        if(multipleChoiceModel.choices?.count == 4) {
                            outputConfiguration.append(multipleChoiceModel);
                        }
                        break;
                    
                    // feedback required
                    case FeedbackRequiredTypes.FeedbackRequired.rawValue:
                        var feedbackRequiredModel = FeedbackRequiredModel(feedbackRequiredModel: gameSpecificPropertiesDict, itemId : itemId);
                        outputConfiguration.append(feedbackRequiredModel);
                        break;
                        
                    default:
                        break;
                    }
                    
                }
            }
        }
        return outputConfiguration;
    }
    
    /* continue game main algorithm */
    func continueCurrentGame() {
        lock(self) {
            self.currentInputModel = BaseInputModel();
            self.currentInputModel.inputType = InputModelTypes.EmptyInput.rawValue;
            
            var initialStep = self.nextStepIndex;
            
            var delay : Int = 0;
            for stepIndex in initialStep..<self.gameConfiguration.count {
                self.nextStepIndex = stepIndex + 1;
                let objectModel = self.gameConfiguration[stepIndex];
                
                // output => continue
                if(objectModel.isKindOfClass(BaseBoxModel)) {
                    self.currentOutputModelsConfig.append(objectModel as! BaseBoxModel);
                    let boxModel = objectModel as! BaseBoxModel;
                    if(boxModel.delay! == 0) {
                        continue;
                    }
                    else if self.chatMode == .FULL {
                        delay = boxModel.delay!;
                        break;
                    }
                }
                    // input => break
                else if (objectModel.isKindOfClass(BaseInputModel)) && self.chatMode == .FULL {
                    self.currentInputModel = objectModel as! BaseInputModel;
                    break;
                }
                    
                    // feedback required
                else if(objectModel.isKindOfClass(FeedbackRequiredModel)) && self.chatMode == .FULL {
                    var feedbackModel = objectModel as! FeedbackRequiredModel;
                    feedbackModel.uIObjectId = stepIndex;
                    feedbackModel.getFeedbackPageObjects(self.taskId, onCompletion: self.didReturnFeedbackObjects);
                    break;
                }
            }
            
            if(self.didFinishGame() && self.chatMode == .FULL) {
                self.currentInputModel = FinishGameModel();
            }
            
            if(self.chatDelegate != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.chatDelegate?.reloadChatComponents();
                });
                
                if(delay > 0 && !self.didFinishGame()) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] in
                        self?.continueCurrentGame();
                    };
                }
            }
        }
    }
    
    /* callback function for the feedback metadata objects */
    func didReturnFeedbackObjects(objectsArray : NSArray, initialArrayId : Int) {
        lock(self) {
            var newUIObjects : Array<NSObject> = self.parseGameConfiguration(objectsArray);
            
            self.gameConfiguration.removeAtIndex(initialArrayId);
            self.gameConfiguration.splice(newUIObjects, atIndex: initialArrayId);
            self.nextStepIndex = self.nextStepIndex - 1;
            self.continueCurrentGame();
            
        }
    }
    
    func didFinishGame() -> Bool {
        // the game must not end with a FeedbackRequiredModel
        if self.nextStepIndex >= self.gameConfiguration.count {
            let objectModel = self.gameConfiguration.last;
            if objectModel != nil {
                if !objectModel!.isKindOfClass(FeedbackRequiredModel) {
                    return true;
                }
            }
        }
        return false;
    }
    
    func outputsFulfilled() -> Bool {
        for boxModel in self.currentOutputModelsConfig {
            if boxModel.outputFulfilled == false {
                return false;
            }
        }
        return true;
    }
}