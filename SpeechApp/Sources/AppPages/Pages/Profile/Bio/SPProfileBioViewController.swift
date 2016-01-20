//
//  SPProfileBioViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileBioViewController: SPBaseProfileViewController {
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var tableView: UITableView!;
    
    @IBOutlet weak var topView: UIView!;
    @IBOutlet weak var buttonEdit: UIButton!;
    @IBOutlet weak var buttonChangePassword: UIButton!;
    
    var bioModel : ProfileBioModel?;
    var userDetailsModel : UserDetailsModel?;
    weak var containerDelegate : SPMainProfileContainerViewControllerContainerProtocol?;
    
    init(bioModel : ProfileBioModel, userDetailsModel : UserDetailsModel) {
        self.bioModel = bioModel;
        self.userDetailsModel = userDetailsModel;
        super.init(nibName: "SPProfileBioViewController", bundle: nil);
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewBackground.setRoundCorners();
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.registerNib(UINib(nibName: "SPBasicKeyValueTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPBasicKeyValueTableViewCellIdentifier");
        self.tableView.allowsSelection = false;
        
        self.topView.setRoundCorners();
        self.buttonEdit.setRoundCorners();
        self.buttonChangePassword.setRoundCorners();
        
        if self.userDetailsModel?.isBasicLogin == false {
            self.buttonChangePassword.hidden = true;
        }
    }

    override func getPageTitle() -> String {
        return "Bio";
    }
    
    // MARK : tableView delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bioModel!.bioArray.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let keyValueEntry : BasicKeyValueContainerModel = self.bioModel!.bioArray[indexPath.row];
        var cell : SPBasicKeyValueTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPBasicKeyValueTableViewCellIdentifier", forIndexPath:indexPath) as! SPBasicKeyValueTableViewCell;
        cell.labelFieldName.text = keyValueEntry.paramName;
        cell.labelFieldValue.text = keyValueEntry.paramValue;
        return cell;
    }
    @IBAction func buttonEditAction(sender: AnyObject) {
        self.containerDelegate?.editProfile();
    }
    
    @IBAction func buttonChangePasswordAction(sender: AnyObject) {
        self.containerDelegate?.changePassword();
    }
}
