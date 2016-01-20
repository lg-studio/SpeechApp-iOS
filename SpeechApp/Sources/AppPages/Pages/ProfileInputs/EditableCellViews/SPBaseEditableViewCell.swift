//
//  CPBaseEditableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseEditableViewCell: UITableViewCell {
    @IBOutlet weak var labelField: UILabel!;
    
    var isRequired : Bool = false;
    var placeholder : String = "";
    var inited : Bool = false;
    var profileEntry : SPProfileEntryModel?;

    func initCell() {
    }
    
    func reloadCell() {
        if !self.inited {
            self.initCell();
            self.inited = true;
        }
        self.labelField.text = String(format : "%@%@", self.profileEntry!.displayName, (profileEntry!.required ? " *" : ""));
    }
    
    static func registerTableViewIdentifiers(tableView : UITableView) {
        tableView.registerNib(UINib(nibName: "SPTextEditableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPTextEditableViewCellIdentifier");
        tableView.registerNib(UINib(nibName: "SPChoiceEditableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPChoiceEditableViewCellIdentifier");
        tableView.registerNib(UINib(nibName: "SPImageEditableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPImageEditableViewCellIdentifier");
        tableView.registerNib(UINib(nibName: "SPSubmitEditableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPSubmitEditableViewCellIdentifier");
    }
    
    func getHeight() -> CGFloat {
        return 0.0;
    }
}
