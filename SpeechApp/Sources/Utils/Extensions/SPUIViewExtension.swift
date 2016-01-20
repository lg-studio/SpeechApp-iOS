//
//  SPUIViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import MONActivityIndicatorView

extension UIView : MONActivityIndicatorViewDelegate {
    func setRoundCorners() {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
    }
    
    func setDefaultMarginColor() {
        self.layer.borderColor = UIColor( red: 36/255, green: 102/255, blue:4/255, alpha: 1.0 ).CGColor;
        self.layer.borderWidth = 2.0
    }
    func setRedMarginColor() {
        self.layer.borderColor = UIColor( red: 255/255, green: 0/255, blue:0/255, alpha: 1.0 ).CGColor;
        self.layer.borderWidth = 2.0
    }
    
    func removeAllSubviews () {
        for subview in self.subviews {
            subview.removeFromSuperview();
        }
    }
    
    // activity indicator extension
    func addActivityIndicator() {
        let indicatorView = MONActivityIndicatorView();
        indicatorView.delegate = self;
        indicatorView.delay = 0.1;
        indicatorView.duration = 0.4;
        
        let indicatorViewSize = indicatorView.intrinsicContentSize();
        let horizontal = self.frame.size.width / 2 - indicatorViewSize.width / 2;
        let vertical = self.frame.size.height / 2 - indicatorViewSize.height / 2;
        
        self.addSubview(indicatorView);
        
        let leadingConstraint = NSLayoutConstraint(item: indicatorView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: horizontal);
        let trailingConstraint = NSLayoutConstraint(item: indicatorView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: horizontal);
        let topConstraint = NSLayoutConstraint(item: indicatorView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: vertical);
        let bottomConstraint = NSLayoutConstraint(item: indicatorView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: vertical);
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]);
        
        indicatorView.setTranslatesAutoresizingMaskIntoConstraints(false);
        indicatorView.startAnimating();
    }
    static func removeActivityIndicator(view : UIView?) {
        if let optionalView = view {
            for subview in optionalView.subviews {
                if subview.isKindOfClass(MONActivityIndicatorView) {
                    if let indicatorView = subview as? MONActivityIndicatorView {
                        indicatorView.stopAnimating();
                        indicatorView.removeFromSuperview();
                        return;
                    }
                }
            }
        }
    }
    // MONActivityIndicatorViewDelegate functions
    public func activityIndicatorView(activityIndicatorView: MONActivityIndicatorView!, circleBackgroundColorAtIndex index: UInt) -> UIColor! {
        let indicatorViewColors = [  UIColor(red: 216.0/255, green: 31.0/255.0, blue: 31.0/255.0, alpha: 1.0),
            UIColor.lightGrayColor(),
            UIColor(red: 252.0/255, green: 207.0/255.0, blue: 71.0/255.0, alpha: 1.0),
            UIColor(red: 44.0/255, green: 100.0/255.0, blue: 214.0/255.0, alpha: 1.0),
            UIColor(red: 43.0/255, green: 169.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        ]
        return indicatorViewColors[Int(index)];
    }
}
