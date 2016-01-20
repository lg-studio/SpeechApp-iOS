//
//  SPProfileTasksTaskEntryTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileTasksTaskEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!;
    @IBOutlet weak var label1: UILabel!;
    @IBOutlet weak var label2: UILabel!;
    @IBOutlet weak var imageRight: UIImageView!;

    var taskGradeModel : SPProfileTaskGradeModel?;
    
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
        self.label1.text = self.taskGradeModel!.getTaskName();
        self.label2.text = self.taskGradeModel!.getFeedbackScore();
        if self.taskGradeModel!.isExpandable() {
            self.imageRight.hidden = false;
            if self.taskGradeModel!.expanded {
                self.imageRight.image = UIImage(named: "DownArrowExpandColoured");
            }
            else {
                self.imageRight.image = UIImage(named: "RightArrowExpandColoured");
            }
            self.selectionStyle = .Default;
        }
        else {
            self.selectionStyle = .None;
            self.imageRight.hidden = true;
        }
    }
    
}
