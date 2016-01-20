//
//  SPChatRatingInputBaseViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

protocol SPChatRatingInputViewCellProtocol : class {
    func didAddScoreOnCell(score : Float, cellIndex : Int);
    func getLabelByRating(cellIndex: Int) -> String;
    func getAllLabels(cellIndex: Int) -> [String];
}

class SPChatRatingInputBaseViewCell: UITableViewCell {
    @IBOutlet weak var labelText: UILabel!;
    @IBOutlet weak var labelScore: UILabel!;
    
    weak var ratingDelegate : SPChatRatingInputViewCellProtocol?;
    var metricTableIndex : Int?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
    }
    
    func initCellFromModel(metricModel : RatingMetricModel, metricTableIndex : Int) {
        self.labelText.text = metricModel.text;
        self.metricTableIndex = metricTableIndex;
    }
    
    func changeScoreLabel (rating : Float) {
        self.labelScore.text = String(format: "%d%%", Int(rating * 100.0));
    }
    
}