//
//  BorderLabel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class UIBorderedLabel: UILabel {
    func getEdgeInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5);
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let edgeInsets = getEdgeInsets();
        var rect = edgeInsets.apply(bounds)
        rect = super.textRectForBounds(rect, limitedToNumberOfLines: numberOfLines)
        return edgeInsets.inverse.apply(rect)
    }
    
    override func drawTextInRect(rect: CGRect) {
        let edgeInsets = getEdgeInsets();
        super.drawTextInRect(edgeInsets.apply(rect))
    }
}

extension UIEdgeInsets {
    var inverse : UIEdgeInsets {
        get { return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right) }
    }
    func apply(rect: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(rect, self)
    }
}