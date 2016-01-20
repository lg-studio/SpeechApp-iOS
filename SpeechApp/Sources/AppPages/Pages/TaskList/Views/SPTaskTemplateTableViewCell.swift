//
//  SPTaskTemplateTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPTaskTemplateTableViewCell: SPBaseItemTableViewCell {
    weak var taskTemplateModel : SPTaskTemplateModel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func reloadCell() {
        self.labelTaskName.text = self.taskTemplateModel?.name;
        self.imageViewTask.image = nil;
        self.imageViewTask.imageURL = nil;
        self.imageViewTask.imageURL = NSURL(string: self.taskTemplateModel!.iconUrl);
        
        self.labelProperty1.text = String(format: "%@ Retries", self.taskTemplateModel!.properties!.getRetriesLabel());
        self.labelProperty2.text = String(format: "Average Rating: %@%%", self.taskTemplateModel!.properties!.getAverageRatingLabel());
        self.labelProperty3.text = "";
        
    }
}
