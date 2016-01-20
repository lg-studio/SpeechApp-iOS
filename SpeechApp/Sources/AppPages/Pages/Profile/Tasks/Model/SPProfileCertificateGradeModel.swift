//
//  SPProfileCertificateGradeModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileCertificateGradeModel: NSObject {
    var certificateName : String?;
    var feedback : Double?;
    
    init(inputDict : NSDictionary) {
        if let certificateName = inputDict.objectForKey("Name") as? String {
            self.certificateName = certificateName;
        }
        
        if let feedback = inputDict.objectForKey("Feedback") as? Double {
            self.feedback = feedback;
        }
        
        super.init();
    }
    
    func getCertificateName() -> String {
        if self.certificateName != nil {
            return self.certificateName!;
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
