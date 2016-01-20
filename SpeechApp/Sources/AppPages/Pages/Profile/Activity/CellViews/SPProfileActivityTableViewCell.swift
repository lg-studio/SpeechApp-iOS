//
//  SPProfileActivityTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!;
    @IBOutlet weak var label1: UILabel!;
    @IBOutlet weak var label2: UILabel!;
    @IBOutlet weak var label3: UILabel!;

    var activityModel : SPProfileActivityModel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContainer.setRoundCorners();
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCell() {
        self.label1.text = self.activityModel?.getTaskName();
        self.label2.text = self.activityModel?.getFeedbackScore();
        self.label3.text = self.activityModel?.getCreatedAt();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.activityModel?.estimatedHeight = self.contentView.frame.size.height;
    }
    
}
