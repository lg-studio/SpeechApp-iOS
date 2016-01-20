//
//  SPChangePasswordPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChangePasswordPageViewController: SPBaseFormViewController {
    
    init() {
        super.init(nibName: "SPChangePasswordPageViewController", bundle: nil);
        self.profileModel = SPChangePasswordModel();
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.profileModel = SPChangePasswordModel();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initNavBar("Change Password");
    }
    
    override func submitData() {
        super.submitData();
        
        if self.serviceRunning == true {
            return;
        }
        self.serviceRunning = true;
        
        let chPasswdModel = self.profileModel as! SPChangePasswordModel;
        
        if !self.profileModel .allRequiredFieldsCompleted() {
            SPUtils.displayErrorAlertController("Please complete all the required fields", viewController: self);
            self.tableView.reloadData();
            self.serviceRunning = false;
            return;
        }
        if !chPasswdModel.checkSamePassword() {
            SPUtils.displayErrorAlertController("Please insert the same password!", viewController: self);
            self.tableView.reloadData();
            self.serviceRunning = false;
            return;
        }
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        let parameters = [
            "OldPassword" : chPasswdModel.getOldPassword(),
            "NewPassword" : chPasswdModel.getNewPassword()
        ];
        println(parameters);
        httpUtilities.postAnimated(self.view, methodName: "ChangePassword", parameters: parameters,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                self?.serviceRunning = false;
                self?.displayErrorMessage(status);
            },
            onSuccess: {[weak self] (data : NSObject) in
                self?.serviceRunning = false;
                self?.navigationController?.popViewControllerAnimated(true);
            }
        );
    }
}
