//
//  SPChatBaseImagePromptViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 06/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPChatBaseImagePromptViewCell: SPChatBaseViewCell {
    var imagePromptModel : ImagePromptModel?;
    
    @IBOutlet weak var labelTextHeader          : UIBorderedLabel!;
    @IBOutlet weak var centerImageView          : AsyncImageView!;
    @IBOutlet weak var centerImageViewContainer : UIView!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        self.labelTextHeader.setRoundCorners();
        self.centerImageViewContainer.setRoundCorners();
    }
    
    override func reloadCell() {
        labelTextHeader.text = self.imagePromptModel?.textHeader;
        
        if self.imagePromptModel?.textHeader?.length == 0 {
            self.labelTextHeader.hidden = true;
        }
        else {
            self.labelTextHeader.hidden = false;
            labelTextHeader.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 92;
        }
        if imagePromptModel?.imageURL?.length > 0 {
            self.centerImageView.imageURL = NSURL(string: self.imagePromptModel!.imageURL!);
        }
        let tap = UITapGestureRecognizer(target: self, action: Selector("didTapImage:"));
        self.centerImageViewContainer.addGestureRecognizer(tap);
        
        super.reloadCell();
    }
    
    func didTapImage(sender : UIView) {
        if(self.chatPageDelegate != nil) {
            self.chatPageDelegate?.openFullScreenImage(self.imagePromptModel!.imageURL!);
        }
    }
}