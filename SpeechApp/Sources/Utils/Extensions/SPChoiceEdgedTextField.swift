//
//  SPChoiceEdgedTextField.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChoiceEdgedTextField: SPEdgedTextField {
    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero;
    }
    
    override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.isKindOfClass(UILongPressGestureRecognizer) {
            gestureRecognizer.enabled = false;
        }
        super.addGestureRecognizer(gestureRecognizer);
    }
}
