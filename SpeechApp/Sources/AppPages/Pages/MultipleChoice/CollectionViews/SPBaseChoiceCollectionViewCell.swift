//
//  SPBaseChoiceCollectionViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseChoiceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var choiceBackgroundView: UIView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setDefaultCellStyle();
    }
    
    private func setDefaultCellStyle() {
        self.choiceBackgroundView.setRoundCorners();
        self.choiceBackgroundView.setDefaultMarginColor();

        var backgroundView = UIView(frame: self.bounds);
        backgroundView.backgroundColor = UIColor.clearColor();
        self.backgroundView = backgroundView;
        
        var selectedView = UIView(frame: self.bounds);
        selectedView.backgroundColor = UIColor.lightGrayColor();
        self.selectedBackgroundView = selectedView;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if self.selectedBackgroundView != nil {
            let originPoint = self.selectedBackgroundView.frame.origin;
            let frameSize = self.selectedBackgroundView.frame.size;
            
            self.selectedBackgroundView.frame = CGRectMake(originPoint.x + 2, originPoint.y + 2, frameSize.width - 4, frameSize.height - 4);
        }
    }
}
