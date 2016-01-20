//
//  SPProfileEntryModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPProfileEntryModelTypes : String {
    case TextName       =   "TextName"
    case TextEmail      =   "TextEmail"
    case TextPassword   =   "TextPassword"
    case Choice         =   "Choice"
    case Image          =   "Image"
    case Submit         =   "Submit"
}

class SPProfileEntryModel: NSObject {
    var type        : SPProfileEntryModelTypes;
    var entryKey    : String;
    var displayName : String;
    var value       : AnyObject?;
    var required    : Bool  =   true;
    
    var choiceGeneratorModel : SPBaseGeneratorModel?;
    var pickerView : UIPickerView?;
    var estimatedCellheight : CGFloat = 61.0;
    var displayConstraintsErrors : Bool = false;
    
    init(type : SPProfileEntryModelTypes, value : AnyObject?, entryKey : String, displayName : String, required : Bool, choiceGeneratorModel : SPBaseGeneratorModel?) {
        self.type = type;
        self.value = value;
        self.entryKey = entryKey;
        self.displayName = displayName;
        self.required = required;
        self.choiceGeneratorModel = choiceGeneratorModel;
        
        super.init();
        
        if type == .Choice {
            self.pickerView = UIPickerView();
        }
    }
    func isValid() -> Bool {
        switch self.type {
        case .TextEmail:
            if let email = self.value as? String {
                return SPUtils.isValidEmail(email);
            }
            return false;
        default:
            if self.value == nil {
                return false;
            }
            return true;
        }
    }
}
