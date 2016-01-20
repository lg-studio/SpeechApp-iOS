//
//  SPChatRatingInputViewControllerTableViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 05/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPChatRatingInputViewController : UITableViewDataSource {
    func registerCellIdentifiers () {
        for (nibName, cellIdentifier) in self.cellsIdentifiers {
            self.tableViewRating.registerNib(UINib(nibName: nibName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier);
        }
    }
    
    // MARK: UITableViewDataSource delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ratingModel!.metrics!.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var ratingMetric : RatingMetricModel = self.ratingModel!.metrics![indexPath.row];
        var outputCell : SPChatRatingInputBaseViewCell;
        switch ratingMetric.metricType! {
        case RatingMetricTypes.Slider:
            outputCell = tableView.dequeueReusableCellWithIdentifier("SPChatRatingInputSliderViewCellIdentifier", forIndexPath:indexPath) as! SPChatRatingInputSliderViewCell;
            break;
        case RatingMetricTypes.Thumbs:
            outputCell = tableView.dequeueReusableCellWithIdentifier("SPChatRatingInputThumbsViewCellIdentifier", forIndexPath:indexPath) as! SPChatRatingInputThumbsViewCell;
            break;
        default:
            outputCell = SPChatRatingInputBaseViewCell();
            break;
        }
        outputCell.ratingDelegate = self;
        outputCell.initCellFromModel(ratingMetric, metricTableIndex: indexPath.row);

        return outputCell;
    }
}
