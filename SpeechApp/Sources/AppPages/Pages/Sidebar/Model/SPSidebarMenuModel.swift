//
//  SPSidebarMenuModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPSidebarMenuItemTypes : String {
    case Home           =   "Home"
    case Profile        =   "Profile"
    case Notifications  =   "Notifications"
    case LogOut         =   "LogOut"
    case UndefinedItem  =   "UndefinedItem"
    static let allValues = [Home, Profile, Notifications, LogOut]
};

class SPSidebarMenuModel: NSObject {
    // the array of items
    var items : [SPSidebarMenuModelItem];
    var inited : Bool;
    var selectedIndex : Int;
    
    override init() {
        self.items = [];
        self.inited = false;
        self.selectedIndex = 0;
        super.init();
    }
    
    func getSidebarItems(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: "MenuItems", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let items = dataDict["MenuItems"] as? NSArray {
                        for item in items {
                            if let itemDict = item as? NSDictionary {
                                let sidebarItem = SPSidebarMenuModelItem(inputDict: itemDict);
                                if sidebarItem.type == SPSidebarMenuItemTypes.UndefinedItem {
                                    continue;
                                }
                                self?.items.append(sidebarItem);
                            }
                        }
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }

    func getCurrentSelectedItem() -> SPSidebarMenuModelItem {
        return self.items[selectedIndex];
    }
    
}