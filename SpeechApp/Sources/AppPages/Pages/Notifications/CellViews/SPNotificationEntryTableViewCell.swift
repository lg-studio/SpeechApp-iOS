//
//  SPNotificationEntryTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 18/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPNotificationEntryTableViewCell: UITableViewCell {
    @IBOutlet weak var notificationBackground: UIView!;
    @IBOutlet weak var notificationLabel: UILabel!;
    @IBOutlet weak var notificationArrow: UIImageView!;
    
    
    var notification : SPNotificationModel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.notificationBackground.setRoundCorners();
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.notification?.estimatedHeight = self.contentView.frame.size.height;
    }
    
    func reloadCell() {
        self.notificationLabel.text = self.notification!.message;
        if self.notification!.notificationType == .PLAIN_MESSAGE {
            self.notificationArrow.hidden = true;
        }
        else {
            self.notificationArrow.hidden = false;
        }
        if self.notification!.readTimestamp != nil {
            self.notificationLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14);
        }
        else {
            self.notificationLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14);
        }
    }
}
