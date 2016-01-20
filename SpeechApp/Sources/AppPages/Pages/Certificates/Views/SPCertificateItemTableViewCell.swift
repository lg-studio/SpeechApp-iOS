//
//  SPCertificateItemTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPCertificateItemTableViewCell: UITableViewCell {
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var labelCertificateName: UILabel!;
    @IBOutlet weak var labelRightArrow: UIImageView!;
    
    var certificate : SPCertificateItemModel?;

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewBackground.setRoundCorners();
        self.setSelectedBackgroundColor(UIColor(red: 20.0/255.0, green: 64.0/255.0, blue: 20.0/255.0, alpha: 1.0));
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews();
        self.selectedBackgroundView.frame = CGRectMake(self.frame.origin.x + 2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func reloadCell() {
        self.labelCertificateName.text = self.certificate!.name;
        
        if self.certificate!.isExpandable() {
            self.labelRightArrow.alpha = 1.0;
            self.labelRightArrow.image = UIImage(named: self.getImageNameFromCertificate(self.certificate!));
        }
        else {
            self.labelRightArrow.alpha = 0.0;
        }
    }
    
    private func getImageNameFromCertificate(certificate : SPCertificateItemModel) -> String {
        if certificate.expanded == true {
            return "DownArrowExpand";
        }
        return "RightArrowExpand";
    }
}
