//
//  SPBaseItemTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPBaseItemTableViewCell: UITableViewCell {
    static let defaultWidth : CGFloat = 270.0;
    
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var imageViewTask: AsyncImageView!;
    @IBOutlet weak var labelTaskName: UILabel!;
    @IBOutlet weak var labelProperty1: UILabel!;
    @IBOutlet weak var labelProperty2: UILabel!;
    @IBOutlet weak var labelProperty3: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBackground.setRoundCorners();
        self.viewBackground.setDefaultMarginColor();
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews();
        self.selectedBackgroundView.frame = CGRectMake(self.frame.origin.x + 5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
    }
}
