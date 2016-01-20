//
//  RecordingInputModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 01/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class RecordingInputModel: BaseInputModel {
    var linkedEntityId : String?;
    var minLength : Int?;
    var maxLength : Int?;
    var maxRecordings : Int?;
    var maxRetriesPerRecording : Int?;
    
    // the paths to the resulting recordings
    var recordingPaths : [String]?;
    
    override var description : String {
        return "RecordingInputModel [\(self.recordingPaths)]";
    };
    
    override init(inputModel : NSDictionary, itemId : Int, nodeId : Int) {
        super.init(inputModel: inputModel, itemId : itemId, nodeId : nodeId);
        
        self.inputType = InputModelTypes.RecordingInput.rawValue;
        
        self.minLength = 15;
        if let minLength = inputModel.objectForKey("MinLength") as? Int {
            self.minLength = minLength;
        }
        self.maxLength = 60;
        if let maxLength = inputModel.objectForKey("MaxLength") as? Int {
            self.maxLength = maxLength;
        }
        self.maxRecordings = 1;
        if let maxRecordings = inputModel.objectForKey("MaxRecordings") as? Int {
            self.maxRecordings = maxRecordings;
        }
        self.maxRetriesPerRecording = 1;
        if let maxRetriesPerRecording = inputModel.objectForKey("MaxRetriesPerRecording") as? Int {
            self.maxRetriesPerRecording = maxRetriesPerRecording;
        }
        
        self.linkedEntityId = "";
        if let linkedEntityId = inputModel.objectForKey("LinkedEntityId") as? String {
            self.linkedEntityId = linkedEntityId;
        }
        
        self.recordingPaths = [];
    }
    
    func addRecording(recordingPath : String) {
        self.recordingPaths?.append(recordingPath);
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        if let linkedEntityId = aDecoder.decodeObjectForKey("linkedEntityId") as? String {
            self.linkedEntityId = linkedEntityId;
        }
        self.minLength = aDecoder.decodeIntegerForKey("minLength");
        self.maxLength = aDecoder.decodeIntegerForKey("maxLength");
        self.maxRecordings = aDecoder.decodeIntegerForKey("maxRecordings");
        self.maxRetriesPerRecording = aDecoder.decodeIntegerForKey("maxRetriesPerRecording");
        
        if let recordingPaths = aDecoder.decodeObjectForKey("recordingPaths") as? [String] {
            self.recordingPaths = recordingPaths;
        }
        
        super.init(coder: aDecoder);
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.linkedEntityId!, forKey: "linkedEntityId");
        aCoder.encodeInteger(self.minLength!, forKey: "minLength");
        aCoder.encodeInteger(self.maxLength!, forKey: "maxLength");
        aCoder.encodeInteger(self.maxRecordings!, forKey: "maxRecordings");
        aCoder.encodeInteger(self.maxRetriesPerRecording!, forKey: "maxRetriesPerRecording");
        aCoder.encodeObject(self.recordingPaths, forKey: "recordingPaths");
        
        super.encodeWithCoder(aCoder);
    }
}
