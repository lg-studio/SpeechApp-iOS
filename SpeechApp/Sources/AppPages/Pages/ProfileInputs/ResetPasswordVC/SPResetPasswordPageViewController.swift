//
//  SPResetPasswordPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPResetPasswordPageViewController: SPBaseFormViewController {
    weak var loginDelegate : SPLoginPageViewControllerMessageProtocol?;
    
    init() {
        super.init(nibName: "SPResetPasswordPageViewController", bundle: nil);
        
        self.profileModel = SPResetPasswordModel();
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initNavBar("Reset Password");

    }
    override func submitData() {
        super.submitData();
        
        if self.serviceRunning == true {
            return;
        }
        self.serviceRunning = true;
        
        let passwdModel = self.profileModel as! SPResetPasswordModel;
        
        if !passwdModel.allRequiredFieldsCompleted() {
            SPUtils.displayErrorAlertController("Please check the format of the email you entered", viewController: self);
            self.tableView.reloadData();
            self.serviceRunning = false;
            return;
        }
        

        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        let parameters = [
            "Email" : passwdModel.getEmail()
        ];
        println(parameters);
        httpUtilities.postAnimated(self.view, methodName: "PasswordReset", parameters: parameters,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                self?.serviceRunning = false;
                self?.displayErrorMessage(status);
            },
            onSuccess: {[weak self] (data : NSObject) in
                self?.serviceRunning = false;
                self?.goBackWithSuccess();
            }
        );
    }
    func goBackWithSuccess() {
        let loginDelegateCopy = self.loginDelegate!;
        let passwdModel = self.profileModel as! SPResetPasswordModel;
        let messageToSend = String(format: "A temporary password has been sent to %@.", passwdModel.getEmail());
        self.navigationController?.popViewControllerAnimated(true);
        loginDelegateCopy.displayMessage("Info", message: messageToSend);
    }
}
