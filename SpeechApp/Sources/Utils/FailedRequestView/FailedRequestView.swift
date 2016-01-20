//
//  FailedRequestView.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

@objc protocol FailedRequestViewProtocol : class {
    optional func refreshCurrentRequest();
}

class FailedRequestView: UIView {
    var view: UIView!;
    @IBOutlet weak var labelError: UILabel!;
    @IBOutlet weak var buttonRefresh: UIButton!;
    
    weak var refreshDelegate: FailedRequestViewProtocol?;
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame);
        self.commonInit();
    }
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder);
        self.commonInit();
    }
    
    private func commonInit() {
        let subviewArray = NSBundle.mainBundle().loadNibNamed("FailedRequestView", owner: self, options: nil);
        view  = subviewArray[0] as! UIView;
        view.frame = self.bounds;
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight;
        self.addSubview(view);
        self.buttonRefresh.setBackgroundColor(UIColor.lightGrayColor(), forState: .Highlighted);
    }
    
    
    @IBAction func didTapRefreshButton(sender: AnyObject) {
        self.refreshDelegate?.refreshCurrentRequest?();
    }
    
    static func addFailedRequestView(topView : UIView, refreshDelegate : FailedRequestViewProtocol) -> FailedRequestView {
        let reqView = FailedRequestView();
        reqView.refreshDelegate = refreshDelegate;
        topView.addSubview(reqView);
        
        let horizontalConstraint = NSLayoutConstraint(item: reqView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0);
        topView.addConstraint(horizontalConstraint);
        
        let verticalConstraint = NSLayoutConstraint(item: reqView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: topView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0);
        topView.addConstraint(verticalConstraint);
        
        let widthConstraint = NSLayoutConstraint(item: reqView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 150);
        reqView.addConstraint(widthConstraint);
        
        let heightConstraint = NSLayoutConstraint(item: reqView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 250);
        reqView.addConstraint(heightConstraint);
     
        reqView.setTranslatesAutoresizingMaskIntoConstraints(false);
        return reqView;
    }
}
