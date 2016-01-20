//
//  SPSignUpPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPSignUpPageViewController: SPBaseFormViewController {
    weak var loginDelegate : SPLoginPageViewControllerMessageProtocol?;
    var email : String = "";
    
    init() {
        super.init(nibName: "SPSignUpPageViewController", bundle: nil);
        self.profileModel = SPProfileModel();
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        self.initNavBar("Sign Up");
    }
}