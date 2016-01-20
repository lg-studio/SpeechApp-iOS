//
//  SPChatUserInputContainer.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 09/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import SwiftHTTP

class SPChatUserInputContainerModel: NSObject, NSCoding {
    // the id of the task that is created on the server
    var taskId : String;
    
    // the player user's id
    var userId : String = "";
    
    // the array of the user's inputs that will be sent to the server
    var userInputs : [BaseInputModel];
    
    var inputDict : NSDictionary?;
    var httpUploads : [String] = [];
    
    override var description : String {
        return "SPChatUserInputContainerModel [\(self.userInputs)]";
    };
    
    override init() {
        self.taskId = "";
        self.userInputs = [];
        
        let dbUserId = UserDetailsModel.loadUserDetailsModel().userId;
        if dbUserId != nil {
            self.userId = dbUserId!;
        }
    }
    
    func addUserInput(inputModel : BaseInputModel) {
        self.userInputs.append(inputModel);
    }
    
    func sendToServer() {
        self.encodeAsJSON();
        self.setRecordingPaths();
        
        var httpUploadsCopy = self.httpUploads;
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.postFilesWithJson("TaskInput", jsonName: "Inputs", json: self.inputDict!, filePaths: self.httpUploads,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                println("[ERROR] Problem getting chat objects: \(status)");
                SPUtils.deleteFilesFromDocumentsDirectory(httpUploadsCopy);
            },
            onSuccess: {[weak self] (data : NSObject) in
                SPUtils.deleteFilesFromDocumentsDirectory(httpUploadsCopy);
            }
        );
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        self.userId = "";
        self.taskId = "";
        self.userInputs = [];
        if let userInputs = aDecoder.decodeObjectForKey("userInputs") as? [BaseInputModel] {
            self.userInputs = userInputs;
        }
        if let taskId = aDecoder.decodeObjectForKey("taskId") as? String {
            self.taskId = taskId;
        }
        if let userId = aDecoder.decodeObjectForKey("userId") as? String {
            self.userId = userId;
        }
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userInputs, forKey: "userInputs");
        aCoder.encodeObject(self.taskId, forKey : "taskId");
        aCoder.encodeObject(self.userId, forKey : "userId");
    }
    
    // encode the inputs as JSON object
    private func encodeAsJSON() {
        var inputDict = NSMutableDictionary();
        inputDict.setObject(self.taskId, forKey: "TaskId");
        // rating
        var ratingsArray = NSMutableArray();
        for userInput in self.userInputs {
            if let ratingModel = userInput as? RatingInputModel {
                ratingsArray.addObject(ratingModel.getRatingInputsArray());
            }
        }
        inputDict.setObject(ratingsArray, forKey: "Ratings");
        
        // answers
        var answersArray = NSMutableArray();
        for userInput in self.userInputs {
            if let recordingModel = userInput as? RecordingInputModel {
                var recordingDict = NSMutableDictionary();
                recordingDict.setObject(recordingModel.nodeId, forKey: "NodeId");
                
                var fileNames = NSMutableArray();
                for path in recordingModel.recordingPaths! {
                    fileNames.addObject(path.lastPathComponent);
                }
                recordingDict.setObject(fileNames, forKey: "FileNames");
                
                answersArray.addObject(recordingDict);
            }
        }
        inputDict.setObject(answersArray, forKey: "Answers");
        self.inputDict = inputDict;
    }
    
    private func setRecordingPaths() {
        self.httpUploads = [];
        for userInput in self.userInputs {
            if let recordingModel = userInput as? RecordingInputModel {
                for path in recordingModel.recordingPaths! {
                    self.httpUploads.append(path);
                }
            }
        }
    }
    
    func cleanLocalFiles() {
        self.setRecordingPaths();
        SPUtils.deleteFilesFromDocumentsDirectory(self.httpUploads);
    }
    
    
    
    
}