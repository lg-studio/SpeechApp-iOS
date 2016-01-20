//
//  UIHorizontalBorderedLabel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class UIHorizontalBorderedLabel: UIBorderedLabel {
    override func getEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    }
}
