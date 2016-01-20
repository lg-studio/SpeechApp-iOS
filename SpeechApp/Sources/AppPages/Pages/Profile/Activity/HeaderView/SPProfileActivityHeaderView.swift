//
//  SPProfileActivityHeaderView.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileActivityHeaderView: UIView {
    @IBOutlet var view: UIView!;

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame);
        self.commonInit();
    }
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder);
        self.commonInit();
    }
    
    private func commonInit() {
        let subviewArray = NSBundle.mainBundle().loadNibNamed("SPProfileActivityHeaderView", owner: self, options: nil);
        view  = subviewArray[0] as! UIView;
        view.frame = self.bounds;
        view.autoresizingMask = .FlexibleWidth | .FlexibleHeight;
        self.addSubview(view);
    }
    

}
