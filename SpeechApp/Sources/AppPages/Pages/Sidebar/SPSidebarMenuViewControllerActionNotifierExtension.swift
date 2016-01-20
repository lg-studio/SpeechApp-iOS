//
//  SPSidebarMenuViewControllerActionNotifierExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPSidebarMenuViewController {
    func handleAction() {
        let item : SPSidebarMenuModelItem = self.sideBarModel!.getCurrentSelectedItem();
        
        switch item.type {
        case SPSidebarMenuItemTypes.Home:
            self.sidebarDelegate?.goToMainPage();
            break;
        case SPSidebarMenuItemTypes.Profile:
            self.sidebarDelegate?.goToProfilePage();
            break;
        case SPSidebarMenuItemTypes.Notifications:
            self.sidebarDelegate?.goToNotificationsPage();
            break;
        case SPSidebarMenuItemTypes.LogOut:
            self.sidebarDelegate?.logout();
            break;
        default:
            break;
        }
        
    }
}