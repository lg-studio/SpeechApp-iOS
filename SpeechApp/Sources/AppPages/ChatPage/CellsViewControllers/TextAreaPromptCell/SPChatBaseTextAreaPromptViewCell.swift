//
//  SPChatBaseTextAreaPromptViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 06/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPChatBaseTextAreaPromptViewCell: SPChatBaseViewCell {
    var textAreaPromptModel : TextAreaPromptModel?;

    @IBOutlet weak var labelTextHeader  : UIBorderedLabel!;
    @IBOutlet weak var labelContent     : UIBorderedLabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        self.labelTextHeader.setRoundCorners();
        self.labelContent.setRoundCorners();
    }
    
    override func reloadCell() {
        labelTextHeader.text = self.textAreaPromptModel?.textHeader;
        
        if self.textAreaPromptModel?.textHeader?.length == 0 {
            self.labelTextHeader.hidden = true;
        }
        else {
            self.labelTextHeader.hidden = false;
            labelTextHeader.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 92;
        }
        
        labelContent.text = self.textAreaPromptModel?.textContent;
        labelContent.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 92;
        
        super.reloadCell();
    }
}