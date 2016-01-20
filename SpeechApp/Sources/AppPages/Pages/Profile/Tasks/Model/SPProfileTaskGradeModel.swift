//
//  SPProfileTaskGradeModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileTaskGradeModel: NSObject {
    var taskName : String?;
    var feedback : Double?;
    var certificates : [SPProfileCertificateGradeModel];
    
    var expanded : Bool;
    
    init(inputDict : NSDictionary) {
        if let taskName = inputDict.objectForKey("TaskName") as? String {
            self.taskName = taskName;
        }
        
        if let feedback = inputDict.objectForKey("Feedback") as? Double {
            self.feedback = feedback;
        }
        
        self.certificates = [];
        if let certificatesArray = inputDict.objectForKey("Certificates") as? NSArray {
            for certificateData in certificatesArray {
                if let certificateDict = certificateData as? NSDictionary {
                    self.certificates.append(SPProfileCertificateGradeModel(inputDict : certificateDict));
                }
            }
        }
        
        self.expanded = false;
        
        super.init();
    }
    
    func isExpandable() -> Bool {
        if self.certificates.count > 0 {
            return true;
        }
        return false;
    }
    
    func getTaskName() -> String {
        if self.taskName != nil {
            return self.taskName!;
        }
        return "-";
    }
    func getFeedbackScore() -> String {
        if self.feedback != nil {
            return self.computePercentageString(self.feedback!);
        }
        return "-";
    }
}
