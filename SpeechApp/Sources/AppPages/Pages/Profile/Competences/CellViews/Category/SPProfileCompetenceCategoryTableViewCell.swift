//
//  SPProfileCompetenceCategoryTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileCompetenceCategoryTableViewCell: SPProfileCompetenceBaseTableViewCell {
    @IBOutlet weak var backgroundContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundContainerView.setRoundCorners();
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
