//
//  SPMainProfileContainerViewControllerContainerExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

protocol SPMainProfileContainerViewControllerContainerProtocol : class {
    func editProfile();
    func changePassword();
    func refreshProfileBio();
    func didTapTaskInProfileActivity(taskId : String, taskName : String?);
}

extension SPMainProfileContainerViewController : SPMainProfileContainerViewControllerContainerProtocol {
    func editProfile() {
        var profileEditPageVC = SPEditProfilePageViewController(profileBio: self.profileBio);
        profileEditPageVC.containerDelegate = self;
        self.navigationController?.pushViewController(profileEditPageVC, animated: true);
    }
    func changePassword() {
        var changePasswdVC = SPChangePasswordPageViewController();
        self.navigationController?.pushViewController(changePasswdVC, animated: true);
    }
    
    func refreshProfileBio() {
        self.profileBio.inited = false;
        self.getProfilePageInfo();
    }

    func didTapTaskInProfileActivity(taskId : String, taskName : String?) {
        // open chat page in read only mode
        var chatPageVC = SPChatPageViewController(taskId : taskId, defaultNodeId : nil, taskName : taskName);
        self.navigationController?.pushViewController(chatPageVC, animated: true);
    }

}
