//
//  SPTaskItemTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPTaskItemTableViewCell: SPBaseItemTableViewCell {
    
    weak var topicModel : SPTopicModel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCell() {
        self.labelTaskName.text = self.topicModel?.name;
        self.imageViewTask.image = nil;
        self.imageViewTask.imageURL = nil;
        self.imageViewTask.imageURL = NSURL(string: self.topicModel!.iconUrl);
        
        self.labelProperty1.text = String(format: "Average Score: %@%%", topicModel!.properties!.getAverageScoreLabel());
        self.labelProperty2.text = String(format: "Minutes Spent: %@", topicModel!.properties!.getMinutesSpentLabel());
        
        if topicModel!.hasSingleTask() == false {
            self.labelProperty3.text = String(format: "%d Exertices", topicModel!.getTaskNumbers());
        }
        else {
            self.labelProperty3.text = "";
        }
        
    }
}
