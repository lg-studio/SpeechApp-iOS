//
//  SPContainerCenterUIViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import JASidePanels

class SPContainerCenterUIViewController: UIViewController {
    weak var panelContainerDelegate: SPMainContainerViewControllerCenterVCProtocol?;

    override func viewDidLoad() {
        super.viewDidLoad();

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