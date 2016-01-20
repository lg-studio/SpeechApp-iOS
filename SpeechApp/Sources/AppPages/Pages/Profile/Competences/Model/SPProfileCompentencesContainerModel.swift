//
//  SPProfileCompentencesContainerModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileCompentencesContainerModel: NSObject {
    var competences : [SPProfileCompentenceEntryModel] = [];
    var inited : Bool;
    
    override init() {
        self.inited = false;
        super.init();
    }
    
    func getProfileCompetences(view : UIView, onFinished : ((Void) -> Void)) {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.getAnimated(view, methodName: "ProfileCompetences", parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                onFinished();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    if let headerArray = dataDict.objectForKey("Competences") as? NSArray {
                        self?.competences = [];
                        
                        for headerData in headerArray {
                            if let headerDict = headerData as? NSDictionary {
                                var header = SPProfileCompentenceEntryModel(inputDict: headerDict);
                                header.type = .Header;
                                self?.competences.append(header);
                                
                                if let categoriesArray = headerDict.objectForKey("Children") as? NSArray {
                                    for categoryData in categoriesArray {
                                        if let categoryDict = categoryData as? NSDictionary {
                                            var competence = SPProfileCompentenceEntryModel(inputDict : categoryDict);
                                            competence.type = .Category;
                                            self?.competences.append(competence);
                                            
                                            if let subcategoriesArray = categoryDict.objectForKey("Children") as? NSArray {
                                                for var k = 0; k < subcategoriesArray.count; k++ {
                                                    if let subcategoryDict = subcategoriesArray.objectAtIndex(k) as? NSDictionary {
                                                        var subcompetence = SPProfileCompentenceEntryModel(inputDict : subcategoryDict);
                                                        if k == 0 {
                                                            subcompetence.type = .SubcategoryWithHeader;
                                                        }
                                                        else {
                                                            subcompetence.type = .Subcategory;
                                                        }
                                                        self?.competences.append(subcompetence);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        self?.inited = true;
                    }
                }
                onFinished();
            });
    }
    
}
