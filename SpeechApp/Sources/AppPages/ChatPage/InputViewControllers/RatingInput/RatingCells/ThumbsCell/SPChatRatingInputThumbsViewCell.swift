//
//  SPChatRatingInputThumbsViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatRatingInputThumbsViewCell: SPChatRatingInputBaseViewCell {
    @IBOutlet weak var viewThumbsUp: UIView!
    @IBOutlet weak var buttonThumbsUp: UIButton!

    @IBOutlet weak var viewThumbsDown: UIView!
    @IBOutlet weak var buttonThumbsDown: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func initCellFromModel(metricModel : RatingMetricModel, metricTableIndex : Int) {
        super.initCellFromModel(metricModel, metricTableIndex: metricTableIndex);
        
        self.buttonThumbsUp.alpha = 0.45;
        self.buttonThumbsDown.alpha = 0.45;
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func buttonThumbsUpPressed(sender: AnyObject) {
        self.buttonThumbsUp.alpha = 1.0;
        self.buttonThumbsDown.alpha = 0.45;
        if self.ratingDelegate != nil {
            self.ratingDelegate!.didAddScoreOnCell(1.0, cellIndex:self.metricTableIndex!);
        }
    }
    
    @IBAction func buttonThumbsDownPressed(sender: AnyObject) {
        self.buttonThumbsUp.alpha = 0.45;
        self.buttonThumbsDown.alpha = 1.0;
        if self.ratingDelegate != nil {
            self.ratingDelegate!.didAddScoreOnCell(0.0, cellIndex:self.metricTableIndex!);
        }
    }
    
}
