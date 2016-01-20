//
//  SPLoginPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 27/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

protocol SPLoginPageViewControllerMessageProtocol : class {
    func displayMessage(title : String, message : String);
}

class SPLoginPageViewController: UIViewController, UITextFieldDelegate, SPLoginPageViewControllerMessageProtocol {
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var textFieldEmail: SPEdgedTextField!;
    @IBOutlet weak var textFieldPassword: SPEdgedTextField!;
    @IBOutlet weak var buttonLogin: UIButton!;
    
    @IBOutlet weak var buttonFacebook: UIButton!;
    @IBOutlet weak var buttonTwitter: UIButton!;
    @IBOutlet weak var buttonGoogle: UIButton!;
    
    @IBOutlet weak var buttonResetPassword: UIButton!;
    @IBOutlet weak var buttonSignUp: UIButton!;
    
    var facebookConnect : FacebookConnect?;
    var twitterConnect : TwitterConnect?;
    var googleConnect : GooglePlusConnect?;
    
    var isSessionTimeout : Bool = false;
    var isBasicLogin : Bool = true;
    
    init(isSessionTimeout : Bool) {
        self.isSessionTimeout = isSessionTimeout;
        super.init(nibName: "SPLoginPageViewController", bundle: nil);
    }
    
    init() {
        super.init(nibName: "SPLoginPageViewController", bundle: nil);
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initNavBar("SpeechApp");
        self.edgesForExtendedLayout = UIRectEdge.None;
        self.automaticallyAdjustsScrollViewInsets = false;
        
        self.viewBackground.setRoundCorners();
        self.textFieldEmail.setRoundCorners();
        self.textFieldPassword.setRoundCorners();
        self.buttonLogin.setRoundCorners();
        self.buttonSignUp.setRoundCorners();
        self.buttonResetPassword.setRoundCorners();
        
        self.buttonFacebook.setRoundCorners();
        self.buttonTwitter.setRoundCorners();
        self.buttonGoogle.setRoundCorners();
        
        if self.isSessionTimeout {
            SPUtils.displayErrorAlertController("Session Timeout", viewController: self);
        }
        
        self.initLoginProviders();
    }
    
    @IBAction func buttonLoginAction(sender: AnyObject) {
        self.standardLogin();
    }
    
    // MARK : UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    // Dismiss keyboard when viewcontroller is touched
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }
    
    func standardLogin() {
        let email = self.textFieldEmail.text;
        let password = self.textFieldPassword.text;
        
        if email.length == 0 || password.length == 0 {
            SPUtils.displayErrorAlertController("Please complete both the username and password!", viewController: self);
            return;
        }
        
        let parameters = [
            "LoginType" : "Basic",
            "Email" : email,
            "Password" : password
        ];
        
        self.view.addActivityIndicator();
        self.doLogin(parameters, isBasicLogin: true);
    }
    
    func doLogin(parameters : Dictionary<String,AnyObject>, isBasicLogin : Bool) {
        self.isBasicLogin = isBasicLogin;
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.post("Login", parameters: parameters,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                if self != nil {
                    UIView.removeActivityIndicator(self!.view);
                    SPUtils.displayErrorAlertController(status, viewController: self!);
                }
            },
            onSuccess: {[weak self] (data : NSObject) in
                if self == nil {
                    return;
                }
                UIView.removeActivityIndicator(self!.view);
                if let dataDict = data as? NSDictionary {
                    if let userDetailsDict = dataDict.objectForKey("UserDetails") as? NSDictionary {
                        let userDetailsModel = UserDetailsModel(inputModel: userDetailsDict, isBasicLogin : self?.isBasicLogin);
                        userDetailsModel.persist();
                        
                        UIView.animateWithDuration(0.6, animations: { () -> Void in
                            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                            self?.navigationController?.pushViewController(SPMainContainerViewController(), animated: false);
                            UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromRight, forView: self!.navigationController!.view!, cache: false)
                        });
                        let pushNotifModel = PushNotificationsModel();
                        pushNotifModel.sendNotificationKeyToServer();
                    }
                }
            }
        );
    }
    
    // button outlets
    @IBAction func buttonFacebookAction(sender: AnyObject) {
        self.loginWithFacebook();
    }
    @IBAction func buttonTwitterAction(sender: AnyObject) {
        self.loginWithTwitter();
    }
    @IBAction func buttonGoogleAction(sender: AnyObject) {
        self.loginWithGoogle();
    }
    @IBAction func buttonSignUpAction(sender: AnyObject) {
        let signUpVC = SPSignUpPageViewController();
        signUpVC.loginDelegate = self;
        self.navigationController?.pushViewController(signUpVC, animated: true);
    }
    
    @IBAction func buttonResetPasswordAction(sender: AnyObject) {
        var resetPasswdVC = SPResetPasswordPageViewController();
        resetPasswdVC.loginDelegate = self;
        self.navigationController?.pushViewController(resetPasswdVC, animated: true);
    }
    
    // MARK : SPLoginPageViewControllerMessageProtocol
    func displayMessage(title : String, message : String) {
        SPUtils.displayAlertController(title, message: message, viewController: self);
    }

}
