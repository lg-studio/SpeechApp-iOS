//
//  SPSubcertificateItemTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 18/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPSubcertificateItemTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var labelSubcategoryName: UILabel!;
    
    var subcertificate : SPCertificateSubcategoryItemModel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBackground.setRoundCorners();
        self.setSelectedBackgroundColor(UIColor(red: 20.0/255.0, green: 64.0/255.0, blue: 20.0/255.0, alpha: 1.0));
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.selectedBackgroundView.frame = CGRectMake(self.frame.origin.x + 47, 2, self.frame.size.width - 94, self.frame.size.height - 4);
    }
    
    func reloadCell() {
        self.labelSubcategoryName.text = self.subcertificate!.name;
    }
    
    
}
