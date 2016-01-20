//
//  SPCountryGeneratorModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPCountryGeneratorModel: SPBaseGeneratorModel {
    override init () {
        super.init();
        self.generateCountries();
    }
    
    func generateCountries() {
        var countries : [String] = [];
        if let countryCodes = NSLocale.ISOCountryCodes() as? [String] {
            for code in countryCodes {
                let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
                let name = NSLocale(localeIdentifier: "en_UK").displayNameForKey(NSLocaleIdentifier, value: id);
                if name != nil {
                    countries.append(name!);
                }
            }
        }
        var sortedCountries = countries.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
        
        self.values = sortedCountries;
        self.defaultValue = "Germany";
    }
    
}
