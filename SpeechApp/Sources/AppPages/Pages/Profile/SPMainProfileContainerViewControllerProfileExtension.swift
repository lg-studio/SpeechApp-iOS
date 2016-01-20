//
//  SPMainProfileContainerViewControllerProfileExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPMainProfileContainerViewController : FailedRequestViewProtocol {
    func initProfileView() {
        self.imageViewProfileBackground.setRoundCorners();
        self.imageViewProfile.setRoundCorners();
        self.viewProfile.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0);
    }
    
    func getProfilePageInfo() {
        if self.profileBio.inited == true {
            return;
        }
        
        self.profileBio.getProfileBio(self.view, onFinished: {
            [weak self] in
            self?.reloadPage();
        });
        
    }
    
    func reloadPage() {
        if self.profileBio.inited == true {
            self.initPageViewControllers();
            self.initPage();
            self.initProfileView();
            self.initSliderContainer();
            self.updatePage();
            self.updateUserDetailsModelFromProfileBio();
            self.populateProfileView();
            self.slidingViewController.reloadPages();
            self.scrollToCurrentPage();
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
        }
    }
    
    func didTapProfileImageView(sender : UIView) {
        if self.userDetailsModel.imageURL != nil && self.userDetailsModel.imageURL?.length > 0 {
            var fullScreenImageVC = FullScreenImageViewController(imageURL: self.userDetailsModel.imageURL!);
            self.addChildViewControllerOnSubview(fullScreenImageVC, subview: self.view);
        }
    }
    
    func updateUserDetailsModelFromProfileBio() {
        self.userDetailsModel.firstName = self.profileBio.firstName;
        self.userDetailsModel.lastName = self.profileBio.lastName;
        self.userDetailsModel.email = self.profileBio.email;
        self.userDetailsModel.imageURL = self.profileBio.profileImageUrl;
        self.userDetailsModel.persist();
    }
    
    func populateProfileView() {
        self.labelName.text = self.userDetailsModel.getName();
        self.labelEmail.text = self.userDetailsModel.email;
        
        let lastSeen = String(format:"Last Seen: %@", self.profileBio.getLastSeenDateString());
        if self.userDetailsModel.email == nil || self.userDetailsModel.email?.length == 0 {
            self.labelEmail.text = lastSeen;
        }
        else {
            self.labelLastSeen.text = lastSeen;
        }
        
        
        if self.userDetailsModel.imageURL?.length > 0 {
            self.imageViewProfile.imageURL = NSURL(string: self.userDetailsModel.imageURL!);
        }
    }
    
    // MARK : FailedRequestViewProtocol
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.getProfilePageInfo();
    }
}
