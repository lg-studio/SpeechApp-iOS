//
//  SPChatBaseViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit
import AsyncImageView

class SPChatBaseViewCell: UITableViewCell {
    weak var chatPageDelegate : SPChatPageViewControllerChatTableProtocol?;
    var boxModel : BaseBoxModel?;
    
    @IBOutlet weak var userNameLabel: UIHorizontalBorderedLabel!;
    
    @IBOutlet weak var userImageViewContainer: UIView!;
    @IBOutlet weak var userImageView: AsyncImageView!;

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImageViewContainer.setRoundCorners();
        self.userNameLabel.setRoundCorners();
        self.userImageView.contentMode = .ScaleAspectFill;
        self.userImageView.clipsToBounds = true;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews();
        self.boxModel?.estimatedHeight = self.contentView.frame.size.height;
    }
    
    func reloadCell() {
        userImageView.image = nil;
        userImageView.imageURL = nil;
        userImageView.imageURL = NSURL(string: self.boxModel!.userImageURL!);
        
        userNameLabel.text = self.boxModel!.userName;
        self.setNeedsUpdateConstraints();
        self.updateConstraintsIfNeeded();
    }

}