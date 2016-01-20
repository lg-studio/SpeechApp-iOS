//
//  SPLoginPageViewControllerSocialLoginExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 03/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPLoginPageViewController : AFFOAuthDelegate {
    func initLoginProviders() {
        self.facebookConnect = FacebookConnect();
        self.facebookConnect?.delegate = self;
        self.twitterConnect = TwitterConnect();
        self.twitterConnect?.delegate = self;
        self.googleConnect = GooglePlusConnect();
        self.googleConnect?.delegate = self;
    }
    
    func loginWithFacebook() {
        //var fbConnect = FacebookConnect();
        //fbConnect.delegate = self;
        self.facebookConnect?.connectToFB();
    }
    func loginWithTwitter() {
        //var twitterConnect = TwitterConnect();
        //twitterConnect.delegate = self;
        self.twitterConnect?.getAccountsUsingView(self.view);
    }
    func loginWithGoogle() {
        self.googleConnect?.connectToGooglePlus();
    }
 
    func notifyStartLoading() {
        self.view.addActivityIndicator();
    }
    
    func didGetOauthCredentialsWithSuccess(success: Bool, andError err: String!, withToken oAuthToken: String!, tokenSecret oAuthTokenSecret: String!, forProvider provider: String!) {
        if !success {
            UIView.removeActivityIndicator(self.view);
            SPUtils.displayErrorAlertController(err, viewController: self);
            return;
        }
        
        if provider == "Twitter" {
            if oAuthToken == nil || oAuthToken.length == 0 || oAuthTokenSecret == nil || oAuthTokenSecret.length == 0 {
                UIView.removeActivityIndicator(self.view);
                SPUtils.displayErrorAlertController("Please check if the Twitter credentials configured in your Phone's settings are correct.", viewController: self);
                return;
            }
        }
        
        let parameters = [
            "LoginType" : provider,
            "OauthToken" : oAuthToken,
            "OauthTokenSecret" : oAuthTokenSecret
        ];
        
        self.doLogin(parameters, isBasicLogin: false);
        
        // println("oauth key = \(oAuthToken), tokenSecret = \(oAuthTokenSecret), provider = \(provider)");
        
    }
    func viewForActionSheet() -> UIView {
        return self.view;
    }
}