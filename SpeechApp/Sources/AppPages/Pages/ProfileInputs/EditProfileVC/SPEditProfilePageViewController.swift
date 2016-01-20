//
//  SPEditProfilePageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPEditProfilePageViewController: SPBaseFormViewController {
    var profileBio : ProfileBioModel;
    weak var containerDelegate : SPMainProfileContainerViewControllerContainerProtocol?;
    
    init(profileBio : ProfileBioModel) {
        self.profileBio = profileBio;
        
        super.init(nibName: "SPEditProfilePageViewController", bundle: nil);
        
        self.profileModel = SPProfileEditModel(profileBio: profileBio);
    }
    required init(coder aDecoder: NSCoder) {
        self.profileBio = ProfileBioModel();
        super.init(coder: aDecoder);
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initNavBar("Edit Profile");
    }
    
    override func submitData() {
        super.submitData();
        
        if self.serviceRunning == true {
            return;
        }
        self.serviceRunning = true;
        
        let profileBio = self.profileModel as! SPProfileEditModel;
        
        if !self.profileModel.allRequiredFieldsCompleted() {
            SPUtils.displayErrorAlertController("Please complete all the required fields", viewController: self);
            self.tableView.reloadData();
            self.serviceRunning = false;
            return;
        }
        
        profileModel.buildDataToSendToServer();
        
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.postFilesWithJsonAnimated(self.view, methodName: "UpdateBio", jsonName: "AccountData", json: profileModel.jsonToSend!, filePaths: profileModel.filesToUpload!,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                self?.serviceRunning = false;
                self?.displayErrorMessage(status);
            },
            onSuccess: {[weak self] (data : NSObject) in
                self?.serviceRunning = false;
                self?.goBackAndSignalUpdate();
            }
        );
    }
    
    func goBackAndSignalUpdate() {
        self.containerDelegate?.refreshProfileBio();
        self.navigationController?.popViewControllerAnimated(true);
    }
}
