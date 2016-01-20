//
//  SPMainContainerViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import JASidePanels

class SPMainContainerViewController: JASidePanelController, SPMainContainerViewControllerCenterVCProtocol, SPMainContainerViewControllerSidebarVCProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        self.setCenterVC(SPCertificatesPageViewController());
        
        var sidebarVC = SPSidebarMenuViewController();
        sidebarVC.sidebarDelegate = self;
        self.rightPanel = sidebarVC;
        
        
    }
    
    func setCenterVC (vc : SPContainerCenterUIViewController) {
        vc.panelContainerDelegate = self;
        self.centerPanel = UINavigationController(rootViewController: vc);
    }
    
    // MARK: - SPMainContainerViewControllerCenterVCProtocol
    func toggleHamburgerButton(sender : UIBarButtonItem) {
        self.toggleRightPanel(sender);
        
        if let sidebarMenuVC = self.rightPanel as? SPSidebarMenuViewController {
            sidebarMenuVC.reloadTopProfileViewData();
        }
    }
    
    // MARK: - SPMainContainerViewControllerSidebarVCProtocol
    func showCenterPanel() {
        self.showCenterPanelAnimated(true);
    }
    func goToMainPage() {
        self.setCenterVC(SPCertificatesPageViewController());
        self.showCenterPanel();
    }
    func goToProfilePage() {
        self.setCenterVC(SPMainProfileContainerViewController());
        self.showCenterPanel();
    }
    func goToNotificationsPage() {
        var notificationsVC = SPNotificationsPageViewController();
        notificationsVC.panelContainerDelegate = self;
        self.centerPanel = UINavigationController(rootViewController: notificationsVC);
        self.showCenterPanel();
    }
    func logout() {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.post("Logout", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
            },
            onSuccess: {[weak self] (data : NSObject) in
            }
        );
        self.deleteAllCookies();
        self.sendLogoutNotification();
    }
    private func deleteAllCookies() {
        var storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage();
        if let cookies = storage.cookies as? [NSHTTPCookie] {
            for cookie in cookies {
                storage.deleteCookie(cookie);
            }
        }
    }
    func sendLogoutNotification() {
        let logoutNotification = NSNotification(name: SPUtils.LOGOUT_NOTIFICATION, object: false);
        NSNotificationCenter.defaultCenter().postNotification(logoutNotification);
    }
}