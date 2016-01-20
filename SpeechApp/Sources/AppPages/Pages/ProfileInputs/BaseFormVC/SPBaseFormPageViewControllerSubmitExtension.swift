//
//  SPBaseFormPageViewControllerSubmitExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

protocol SPBaseFormViewControllerSubmitProtocol : class {
    func submitData();
}

extension SPBaseFormViewController : SPBaseFormViewControllerSubmitProtocol {
    func submitData() {
        self.displayConstraintsErrors = true;
    }
}
