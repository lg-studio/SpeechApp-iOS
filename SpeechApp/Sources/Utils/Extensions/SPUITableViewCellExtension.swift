//
//  SPUITableViewCellExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import Foundation

extension UITableViewCell {
    override public func awakeFromNib() {
        super.awakeFromNib();
        
        self.separatorInset = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        self.layoutMargins = UIEdgeInsetsZero;
        
    }
    
    func setSelectedBackgroundColor(color : UIColor) {
        var bgColorView = UIView();
        bgColorView.setRoundCorners();
        bgColorView.backgroundColor = color;
        self.selectedBackgroundView = bgColorView;
    }
}