//
//  SPChatRatingInputSliderViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatRatingInputSliderViewCell: SPChatRatingInputBaseViewCell {
    let labelRatingColors = [
        UIColor(red: 163.0/255.0, green: 2.0/255.0, blue: 2.0/255.0, alpha: 1.0),
        UIColor(red: 221.0/255.0, green: 36.0/255.0, blue: 1.0/255.0, alpha: 1.0),
        UIColor(red: 192.0/255.0, green: 65.0/255.0, blue: 3.0/255.0, alpha: 1.0),
        UIColor(red: 158.0/255.0, green: 99.0/255.0, blue: 1.0/255.0, alpha: 1.0),
        UIColor(red: 131.0/255.0, green: 126.0/255.0, blue: 4.0/255.0, alpha: 1.0),
        UIColor(red: 100.0/255.0, green: 157.0/255.0, blue: 5.0/255.0, alpha: 1.0),
        UIColor(red: 76.0/255.0, green: 181.0/255.0, blue: 8.0/255.0, alpha: 1.0),
        UIColor(red: 57.0/255.0, green: 204.0/255.0, blue: 9.0/255.0, alpha: 1.0),
        UIColor(red: 62.0/255.0, green: 223.0/255.0, blue: 2.0/255.0, alpha: 1.0),
        UIColor(red: 72.0/255.0, green: 254.0/255.0, blue: 6.0/255.0, alpha: 1.0)
    ];
    
    @IBOutlet weak var sliderRating: UISlider!;
    @IBOutlet weak var labelRatingResult: UILabel!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func initCellFromModel(metricModel : RatingMetricModel, metricTableIndex : Int) {
        self.sliderRating.setMinimumTrackImage(UIImage(), forState: .Normal);
        self.sliderRating.setMaximumTrackImage(UIImage(), forState: .Normal);
        
        super.initCellFromModel(metricModel, metricTableIndex: metricTableIndex);
        
        self.sliderRating.addTarget(self, action: "sliderValueDidChange:", forControlEvents: UIControlEvents.ValueChanged);
        self.updateLabelValue();
    }
    
    func sliderValueDidChange(slider: UISlider) {
        var sliderValue : Float = slider.value;
        if self.ratingDelegate != nil {
            self.ratingDelegate!.didAddScoreOnCell(sliderValue, cellIndex:self.metricTableIndex!);
        }
        self.changeScoreLabel(sliderValue);
        self.updateLabelValue();
    }
    
    func updateLabelValue() {
        if self.ratingDelegate != nil {
            let valueToShow = self.ratingDelegate!.getLabelByRating(self.metricTableIndex!);
            self.labelRatingResult.text = valueToShow;
            
            let allValues = self.ratingDelegate!.getAllLabels(self.metricTableIndex!);
            if allValues.count == 0 {
                return;
            }
            
            if let index = find(allValues, valueToShow) {
                let fillRatio = Double(index + 1) / Double(allValues.count);
                var colorIndex = Int(fillRatio * Double(labelRatingColors.count - 1));
                if colorIndex >= labelRatingColors.count {
                    colorIndex = labelRatingColors.count - 1;
                }
                if colorIndex < 0 {
                    colorIndex = 0;
                }
                self.labelRatingResult.textColor = self.labelRatingColors[colorIndex];
            }
        }
        else {
            self.labelRatingResult.text = "";
        }
    }
    
}
