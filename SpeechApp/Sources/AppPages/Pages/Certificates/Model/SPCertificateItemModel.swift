//
//  SPCertificateItemModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPCertificateItemModel: NSObject {
    static let NameKey = "Name";
    static let CategoryIdKey = "Id";
    static let SubcategoriesKey = "Subcategories";
    
    var name : String;
    var categoryId : String;
    var subcertificates : [SPCertificateSubcategoryItemModel];
    var expanded : Bool;
    
    init(inputDict : NSDictionary) {
        self.name = "";
        if let name = inputDict.objectForKey(SPCertificateItemModel.NameKey) as? String {
            self.name = name;
        }
        self.categoryId = "";
        if let categoryId = inputDict.objectForKey(SPCertificateItemModel.CategoryIdKey) as? String {
            self.categoryId = categoryId;
        }
        
        self.subcertificates = [];
        if let subcertificatesArray = inputDict.objectForKey(SPCertificateItemModel.SubcategoriesKey) as? NSArray {
            for subcategoryData in subcertificatesArray {
                if let subcategoryDict = subcategoryData as? NSDictionary {
                    self.subcertificates.append(SPCertificateSubcategoryItemModel(inputDict : subcategoryDict, categoryId : self.categoryId));
                }
            }
        }
        self.expanded = false;
        super.init();
    }
    func isExpandable() -> Bool {
        return self.subcertificates.count > 0;
    }
}
