//
//  RatingMetricModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum RatingMetricTypes : String {
    case Slider = "Slider"
    case Thumbs = "Thumbs"
}

class RatingMetricModel: NSObject, NSCoding {
    // the input's type
    var metricType : RatingMetricTypes?;
    var metricId : Int?;
    var text : String?;
    var category : String?;
    var labels : [String] = [];
    
    // user input values
    var ratingSatisfied : Bool?;
    var rating : Float?;
    
    override var description : String {
        return "RatingMetricModel [\(self.metricType?.rawValue), \(self.category), \(self.rating)]";
    };
    
    init(metricModel : NSDictionary) {
        self.metricType = RatingMetricTypes.Slider;
        if let metricType = metricModel.objectForKey("Type") as? String {
            switch metricType {
            case RatingMetricTypes.Slider.rawValue:
                self.metricType = RatingMetricTypes.Slider;
                break;
            case RatingMetricTypes.Thumbs.rawValue:
                self.metricType = RatingMetricTypes.Thumbs;
                break;
            default:
                break;
            }
        }
        
        if let metricId = metricModel.objectForKey("Id") as? Int {
            self.metricId = metricId;
        }
        
        self.labels = [];
        if let propertiesDict = metricModel.objectForKey("Properties") as? NSDictionary {
            if let text = propertiesDict.objectForKey("Text") as? String {
                self.text = text;
            }
            
            if let category = propertiesDict.objectForKey("Category") as? String {
                self.category = category;
            }
            
            if let labelsArray = propertiesDict.objectForKey("Labels") as? NSArray {
                for labelData in labelsArray {
                    if let labelString = labelData as? String {
                        self.labels.append(labelString);
                    }
                }
            }
        }
        
        self.ratingSatisfied = false;
        self.rating = 0.5;
        
        super.init();
    }
    override init() {
        super.init();
    }
    
    func setRating(rating : Float) {
        self.rating = rating;
        self.ratingSatisfied = true;
    }
    
    func getLabelByRating() -> String {
        if self.rating == nil {
            return "";
        }
        if self.labels.count == 0 {
            return "";
        }
        let interval : Float = 1.0 / Float(self.labels.count);
        
        for (var i = 0; i < self.labels.count; i++)  {
            let minValue : Float = interval * Float(i);
            let maxValue : Float = interval * Float(i + 1);
            
            if self.rating! >= minValue && self.rating! <= maxValue {
                return self.labels[i];
            }
        }
        
        return "";
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        if let metricType = aDecoder.decodeObjectForKey("metricType") as? String {
            switch metricType {
            case RatingMetricTypes.Slider.rawValue:
                self.metricType = RatingMetricTypes.Slider;
                break;
            case RatingMetricTypes.Thumbs.rawValue:
                self.metricType = RatingMetricTypes.Thumbs;
                break;
            default:
                self.metricType = RatingMetricTypes.Slider;
                break;
            }
        }
        self.metricId = aDecoder.decodeIntegerForKey("metricId");
        if let text = aDecoder.decodeObjectForKey("text") as? String {
            self.text = text;
        }
        if let category = aDecoder.decodeObjectForKey("category") as? String {
            self.category = category;
        }
        
        self.ratingSatisfied = aDecoder.decodeBoolForKey("ratingSatisfied");
        self.rating = aDecoder.decodeFloatForKey("rating");
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(metricType!.rawValue, forKey: "metricType");
        aCoder.encodeInteger(self.metricId!, forKey: "metricId");
        aCoder.encodeObject(self.text, forKey: "text");
        aCoder.encodeObject(self.category, forKey: "category");
        aCoder.encodeBool(self.ratingSatisfied!, forKey: "ratingSatisfied");
        aCoder.encodeFloat(self.rating!, forKey: "rating");
    }
}