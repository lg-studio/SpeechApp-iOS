//
//  CPTextEditableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPTextEditableViewCell: SPBaseEditableViewCell {
    @IBOutlet weak var textField: SPEdgedTextField!;
    
    override func initCell() {
        self.textField.setRoundCorners();
        self.textField.setDefaultMarginColor();
    }
    override func reloadCell() {
        super.reloadCell();
        
        self.textField.placeholder = self.profileEntry?.displayName;
        if self.profileEntry?.value != nil {
            self.textField.text = SPUtils.convertAnyObjectToString(self.profileEntry!.value!);
        }
        else {
            self.textField.text = "";
        }
        
        switch self.profileEntry!.type {
        case .TextEmail:
            self.textField.keyboardType = .EmailAddress;
            self.textField.autocapitalizationType = .None;
            self.textField.secureTextEntry = false;
            break;
        case .TextName:
            self.textField.keyboardType = .Default;
            self.textField.autocapitalizationType = .Words;
            self.textField.secureTextEntry = false;
            break;
        case .TextPassword:
            self.textField.keyboardType = .Default;
            self.textField.autocapitalizationType = .None;
            self.textField.secureTextEntry = true;
            break;
        default:
            break;
        }
        self.setErrorMarginIfNecessary();
    }
    
    
    func setErrorMarginIfNecessary() {
        if self.profileEntry?.required == true && self.profileEntry?.displayConstraintsErrors == true && self.profileEntry?.isValid() == false {
            self.textField.setRedMarginColor();
        }
        else {
            self.textField.setDefaultMarginColor();
        }
    }
    
    override func getHeight() -> CGFloat {
        return 65.0;
    }
    @IBAction func didChangeTextField(sender: AnyObject) {
        self.profileEntry?.value = self.textField.text;
        if self.textField.text.length == 0 {
            self.profileEntry?.value = nil;
        }
        self.setErrorMarginIfNecessary();
    }
}