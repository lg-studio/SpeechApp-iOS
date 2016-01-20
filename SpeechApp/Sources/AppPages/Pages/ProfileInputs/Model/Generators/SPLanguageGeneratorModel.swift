//
//  SPLanguageGeneratorModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPLanguageGeneratorModel: SPBaseGeneratorModel {
    override init () {
        super.init();
        self.generateLanguages();
    }
    
    func generateLanguages() {
        var languageSet = Set<String>();
        
        if let languagesIdentifiers = NSLocale.availableLocaleIdentifiers() as? [String] {
            for identifier in languagesIdentifiers {
                let language = NSLocale(localeIdentifier: "en_UK").displayNameForKey(NSLocaleLanguageCode, value: identifier);
                if language != nil {
                    languageSet.insert(language!);
                }
            }
        }
        var sortedLanguages = Array(languageSet).sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending };
        
        self.values = sortedLanguages;
        self.defaultValue = "German";
    }
}
