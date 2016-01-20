//
//  SPChatModelServiceExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPChatModel {
    private func getServiceName() -> String {
        switch self.taskTemplateType {
        case .RegularTask:
            return "TaskStructure";
        case .MultipleChoiceTask:
            return "MultipleChoiceTaskStructure";
        }
    }
    
    func getMethodURL() -> String {
        switch self.chatMode {
        case .FULL:
            var urlString = String(format: "%@/%@", self.getServiceName(), self.taskTemplateId);
            
            if self.taskTemplateType == .MultipleChoiceTask {
                
                urlString = String(format: "%@/", urlString);
                
                if self.optionId != nil {
                    urlString = String(format: "%@%d/", urlString, self.optionId!);
                }
                
                if self.subOptionId != nil {
                    urlString = String(format: "%@%d", urlString, self.subOptionId!);
                }
            }
            return urlString;
        case .READ_ONLY:
            return String(format: "RebuildTask/%@", self.taskId);
        }
    }
}
