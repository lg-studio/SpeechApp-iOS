//
//  RatingInputModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class RatingInputModel: BaseInputModel {
    var linkedEntityId : String?;
    var metrics : [RatingMetricModel]?;
    var username : String?;
    
    override var description : String {
        return "RatingInputModel [\(self.metrics)]";
    };
    
    override init(inputModel : NSDictionary, itemId : Int, nodeId : Int) {
        super.init(inputModel: inputModel, itemId : itemId, nodeId : nodeId);
        
        self.inputType = InputModelTypes.RatingInput.rawValue;
        
        self.metrics = [];
        if let metrics = inputModel.objectForKey("Metrics") as? NSArray {
            for metric in metrics {
                var metricModel = RatingMetricModel(metricModel: metric as! NSDictionary);
                self.metrics?.append(metricModel);
            }
        }
        
        self.username = "";
        if let username = inputModel.objectForKey("UserName") as? String {
            self.username = username;
        }
        
        self.linkedEntityId = "";
        if let linkedEntityId = inputModel.objectForKey("LinkedEntityId") as? String {
            self.linkedEntityId = linkedEntityId;
        }
        
        
    }
    
    func satisfiedMetrics() -> Bool {
        for metricModel in self.metrics! {
            if metricModel.ratingSatisfied == false {
                return false;
            }
        }
        return true;
    }
    
    // NSCoding methods
    required init(coder aDecoder: NSCoder) {
        if let linkedEntityId = aDecoder.decodeObjectForKey("linkedEntityId") as? String {
            self.linkedEntityId = linkedEntityId;
        }
        if let metrics = aDecoder.decodeObjectForKey("metrics") as? [RatingMetricModel] {
            self.metrics = metrics;
        }
        if let username = aDecoder.decodeObjectForKey("username") as? String {
            self.username = username;
        }
        
        super.init(coder: aDecoder);
    }
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.linkedEntityId!, forKey: "linkedEntityId");
        aCoder.encodeObject(self.metrics, forKey: "metrics");
        aCoder.encodeObject(self.username, forKey: "username");
        
        super.encodeWithCoder(aCoder);
    }
    
    // get the Dictionary encoding of the rating
    func getRatingInputsArray() -> NSDictionary {
        var ratingDict = NSMutableDictionary();
        
        ratingDict.setObject(self.nodeId, forKey: "NodeId");
        
        var metricsArray = NSMutableArray();
        for metric in self.metrics! {
            var metricDict = NSMutableDictionary();
            metricDict.setObject(metric.metricId!, forKey: "Id");
            metricDict.setObject(metric.category!, forKey: "Type");
            metricDict.setObject(metric.rating!, forKey: "Rating");
            
            metricsArray.addObject(metricDict);
        }
        ratingDict.setObject(metricsArray, forKey: "Metrics");
        
        return ratingDict;
    }
}
