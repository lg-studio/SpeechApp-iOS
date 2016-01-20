//
//  SPYearsGeneratorModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 11/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPYearsGeneratorModel: SPBaseGeneratorModel {
    override init () {
        super.init();
        self.generateYears();
    }
    
    private func generateYears() {
        var years : [Int] = [];
        
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitYear, fromDate: date)
        let currentYear = components.year;
        
        for var year = currentYear-110; year <= currentYear; year++ {
            years.append(year);
        }
        
        self.values = years;
        self.defaultValue = currentYear - 20;
    }
}
