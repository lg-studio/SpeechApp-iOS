//
//  SPCertificateSubcategoryItemModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPCertificateSubcategoryItemModel: NSObject {
    static let NameKey = "Name";
    static let SubcategoryIdKey = "Id";
    
    // the item's type
    var name : String;
    var subcategoryId : String;
    var categoryId : String;
    
    init(inputDict : NSDictionary, categoryId : String) {
        self.name = "";
        if let name = inputDict.objectForKey(SPCertificateSubcategoryItemModel.NameKey) as? String {
            self.name = name;
        }
        self.subcategoryId = "";
        if let subcategoryId = inputDict.objectForKey(SPCertificateSubcategoryItemModel.SubcategoryIdKey) as? String {
            self.subcategoryId = subcategoryId;
        }
        self.categoryId = categoryId;
        super.init();
    }
}
