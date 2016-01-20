//
//  SPMainContainerViewControllerProtocols.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import Foundation


protocol SPMainContainerViewControllerCenterVCProtocol : class {
    func toggleHamburgerButton(sender : UIBarButtonItem);
}


protocol SPMainContainerViewControllerSidebarVCProtocol : class {
    func showCenterPanel();
    func goToMainPage();
    func goToProfilePage();
    func goToNotificationsPage();
    func logout();
}