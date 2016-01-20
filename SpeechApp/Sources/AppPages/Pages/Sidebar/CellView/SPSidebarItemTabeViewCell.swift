//
//  SPSidebarItemTabeViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPSidebarItemTabeViewCell: UITableViewCell {
    static let estimatedCellHeight : CGFloat = 61.0;
    @IBOutlet weak var itemName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setSelectedBackgroundColor(UIColor(red: 20.0/255.0, green: 64.0/255.0, blue: 20.0/255.0, alpha: 1.0));
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
