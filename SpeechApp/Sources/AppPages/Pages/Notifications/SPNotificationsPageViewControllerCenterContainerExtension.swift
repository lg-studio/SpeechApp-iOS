//
//  SPNotificationsPageViewControllerCenterContainerExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 18/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPNotificationsPageViewController {
    func setSidebarIcon() {
        var hamburgerImage:UIImage = UIImage(named: "HamburgerMenuIcon")!;
        hamburgerImage = hamburgerImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
        var haburgerButton = UIBarButtonItem(image: hamburgerImage, style: .Plain, target: self, action: "toggleHamburgerMenuIcon:");
        self.navigationItem.rightBarButtonItem = haburgerButton;
        
        self.edgesForExtendedLayout = UIRectEdge.None;
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    func toggleHamburgerMenuIcon(sender : UIBarButtonItem) {
        self.panelContainerDelegate?.toggleHamburgerButton(sender);
    }
}
