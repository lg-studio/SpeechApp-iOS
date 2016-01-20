//
//  SPLaunchScreenViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPLaunchScreenViewController: UIViewController {

    init() {
        super.init(nibName: "SPLaunchScreenViewController", bundle: nil);
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.checkSession();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        navigationController?.navigationBar.hidden = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        navigationController?.navigationBar.hidden = false;
    }
    
    func checkSession() {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.get("SessionExists", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                self?.goToLoginPage();
            },
            onSuccess: {[weak self] (data : NSObject) in
                self?.goToMainPage();
            }
        );
    }
    
    private func goToLoginPage() {
        self.pushViewController(SPLoginPageViewController());
    }
    private func goToMainPage() {
        self.pushViewController(SPMainContainerViewController());
    }
    
    private func pushViewController(vc : UIViewController) {
        if let appDelegate = UIApplication.sharedApplication().delegate as? SPAppDelegate {
            let homeVC = UINavigationController(rootViewController: vc);
            UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                let oldState = UIView.areAnimationsEnabled();
                UIView.setAnimationsEnabled(false);
                appDelegate.window?.rootViewController = homeVC;
                UIView.setAnimationsEnabled(oldState);
            }, completion: nil);
        }
    }
}
