//
//  SPProfileCompetenceBaseTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileCompetenceBaseTableViewCell: UITableViewCell {
    @IBOutlet weak var label1: UILabel!;
    @IBOutlet weak var label2: UILabel!;
    
    var competence : SPProfileCompentenceEntryModel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadCell() {
        self.label1.text = self.competence!.getCompetenceName();
        self.label2.text = self.competence!.getCompetenceRating();
    }
}
