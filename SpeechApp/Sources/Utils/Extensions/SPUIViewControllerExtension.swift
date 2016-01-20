//
//  SPUIViewControllerExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 09/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import JASidePanels

extension UIViewController {
    private func hasBackVC() -> Bool {
        return self.navigationController?.viewControllers.count > 1;
    }
    
    func initNavBar(title : String) {
        self.title = title;
        self.navigationItem.setHidesBackButton(true, animated: false);
        
        if(self.hasBackVC()) {
            var backImage:UIImage = UIImage(named: "BackLeftArrow")!
            backImage = backImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            var fakeBackButton = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: "goBack:")
            self.navigationItem.leftBarButtonItem = fakeBackButton;
        }
    }
    
    func addChildViewControllerOnSubview(viewControllerToAdd : UIViewController, subview : UIView) {
        self.addChildViewController(viewControllerToAdd);
        viewControllerToAdd.view.frame = subview.bounds;
        subview.addSubview(viewControllerToAdd.view);
        viewControllerToAdd.didMoveToParentViewController(self);
    }
    func removeSelfVCFromParentViewController() {
        self.willMoveToParentViewController(nil);
        self.view.removeFromSuperview();
        self.removeFromParentViewController();
    }
    func goBack(sender : UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func displayErrorMessage(message : String) {
        SPUtils.displayErrorAlertController(message, viewController: self);
    }
    
}