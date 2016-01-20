//
//  SPSidebarMenuModelItem.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPSidebarMenuModelItem: NSObject {
    // the item's type
    var type : SPSidebarMenuItemTypes;
    var name : String;
    
    init(inputDict : NSDictionary) {
        self.name = "";
        if let name = inputDict.objectForKey("Name") as? String {
            self.name = name;
        }
        self.type = SPSidebarMenuItemTypes.UndefinedItem;
        if let type = inputDict.objectForKey("Type") as? String {
            for itemType in SPSidebarMenuItemTypes.allValues {
                if type == itemType.rawValue {
                    self.type = itemType;
                    break;
                }
            }
        }
        
        super.init();
    }
    
}
