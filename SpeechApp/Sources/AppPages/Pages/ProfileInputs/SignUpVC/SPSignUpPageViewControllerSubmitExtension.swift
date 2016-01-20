//
//  SPSignUpPageViewControllerSubmitExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit


extension SPSignUpPageViewController {
    override func submitData() {
        super.submitData();
        
        if self.serviceRunning == true {
            return;
        }
        self.serviceRunning = true;
        
        let profileModel = self.profileModel as! SPProfileModel;
        
        if !self.profileModel .allRequiredFieldsCompleted() {
            SPUtils.displayErrorAlertController("Please complete all the required fields", viewController: self);
            self.tableView.reloadData();
            self.serviceRunning = false;
            return;
        }
        if !profileModel.checkSamePassword() {
            SPUtils.displayErrorAlertController("Please insert the same password!", viewController: self);
            self.tableView.reloadData();
            self.serviceRunning = false;
            return;
        }
        profileModel.buildDataToSendToServer();
        self.email = profileModel.getEmail();
        
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.postFilesWithJsonAnimated(self.view, methodName: "SignUp", jsonName: "AccountData", json: profileModel.jsonToSend!, filePaths: profileModel.filesToUpload!,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                self?.serviceRunning = false;
                self?.displayErrorMessage(status);
            },
            onSuccess: {[weak self] (data : NSObject) in
                self?.serviceRunning = false;
                self?.goToFirstPage(data);
            }
        );
    }
    
    func goToFirstPage(data : NSObject) {
        let loginDelegateCopy = self.loginDelegate!;
        let messageToSend = String(format: "An email has been sent to %@. Please activate your account before logging in.", self.email);
        self.navigationController?.popViewControllerAnimated(true);
        loginDelegateCopy.displayMessage("Info", message: messageToSend);
//        if let dataDict = data as? NSDictionary {
//            if let userDetailsDict = dataDict.objectForKey("UserDetails") as? NSDictionary {
//                let userDetailsModel = UserDetailsModel(inputModel: userDetailsDict, isBasicLogin : true);
//                userDetailsModel.persist();
//                
//                UIView.animateWithDuration(0.6, animations: { () -> Void in
//                    UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
//                    self.navigationController?.pushViewController(SPMainContainerViewController(), animated: false);
//                    UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self.navigationController!.view!, cache: false)
//                });
//                
//                let pushNotifModel = PushNotificationsModel();
//                pushNotifModel.sendNotificationKeyToServer();
//            }
//        }
    }
}
