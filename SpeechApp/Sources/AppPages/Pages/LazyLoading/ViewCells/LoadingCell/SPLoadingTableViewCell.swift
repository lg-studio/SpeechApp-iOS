//
//  SPLoadingTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 14/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPLoadingTableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
