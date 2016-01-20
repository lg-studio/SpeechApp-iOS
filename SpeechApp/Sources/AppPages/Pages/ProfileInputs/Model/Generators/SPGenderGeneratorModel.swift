//
//  SPGenderGeneratorModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPGenderGeneratorModel: SPBaseGeneratorModel {
    override init () {
        super.init();
        self.generateGenders();
    }
    
    private func generateGenders() {
        self.values = ["Male", "Female"];
        self.defaultValue = "Male";
    }
}