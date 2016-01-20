//
//  SPBasicKeyValueTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 28/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBasicKeyValueTableViewCell: UITableViewCell {
    @IBOutlet weak var labelFieldName: UILabel!;
    @IBOutlet weak var constraintLabel1Width: NSLayoutConstraint!;
    @IBOutlet weak var labelFieldValue: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
