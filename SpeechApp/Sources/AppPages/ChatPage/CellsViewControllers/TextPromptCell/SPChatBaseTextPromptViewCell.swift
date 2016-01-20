//
//  SPChatBaseOutputLabelViewCellTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit
import AsyncImageView

class SPChatBaseTextPromptViewCell: SPChatBaseViewCell {
    var textModel : TextPromptModel?;
    @IBOutlet weak var cellTextLabel: UIBorderedLabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        self.cellTextLabel.setRoundCorners();
    }
    
    override func reloadCell() {
        cellTextLabel.text = self.textModel?.text;
        cellTextLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 92;
        super.reloadCell();
    }
}