//
//  SPSubmitEditableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPSubmitEditableViewCell: SPBaseEditableViewCell {
    @IBOutlet weak var buttonSubmit: UIButton!;
    
    weak var submitDelegate: SPBaseFormViewControllerSubmitProtocol?;
    
    override func initCell() {
        self.buttonSubmit.setRoundCorners();
    }
    override func reloadCell() {
        super.reloadCell();
        
        self.buttonSubmit.setTitle(self.profileEntry?.displayName, forState: .Normal);
    }
    override func getHeight() -> CGFloat {
        return 53.0;
    }
    
    @IBAction func buttonSubmitAction(sender: AnyObject) {
        self.submitDelegate?.submitData();
    }
}
