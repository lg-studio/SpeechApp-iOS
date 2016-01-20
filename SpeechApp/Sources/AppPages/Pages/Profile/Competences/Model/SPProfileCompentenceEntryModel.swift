//
//  SPProfileCompentenceEntryModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPProfileCompentenceEntryModelType : String {
    case Header                 =   "Header"
    
    case Category               =   "Category"
    
    case Subcategory            =   "Subcategory"
    case SubcategoryWithHeader  =   "SubcategoryWithHeader"
}

class SPProfileCompentenceEntryModel: NSObject {
    var type : SPProfileCompentenceEntryModelType?;
    
    var competenceName : String?;
    var competenceDescription : String?;
    var competenceRating : Double?;
    
    
    init(inputDict : NSDictionary) {
        if let competenceName = inputDict.objectForKey("Name") as? String {
            self.competenceName = competenceName;
        }
        
        if let competenceDescription = inputDict.objectForKey("Description") as? String {
            self.competenceDescription = competenceDescription;
        }
        
        if let competenceRating = inputDict.objectForKey("Rating") as? Double {
            self.competenceRating = competenceRating;
        }

        super.init();
    }
    
    func getCompetenceName() -> String {
        if self.competenceName != nil {
            return self.competenceName!;
        }
        return "-";
    }
    func getCompetenceDescription() -> String {
        if self.competenceDescription != nil {
            return self.competenceDescription!;
        }
        return self.getCompetenceName();
    }
    func getCompetenceRating() -> String {
        if self.competenceRating != nil {
            return self.computePercentageString(self.competenceRating!);
        }
        return "-";
    }
}
