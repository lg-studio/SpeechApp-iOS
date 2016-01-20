//
//  SPChatRatingInputViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatRatingInputViewController: SPChatBaseInputViewController, SPChatRatingInputViewCellProtocol {
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!;
    @IBOutlet weak var tableViewRating: UITableView!
    let cellsIdentifiers : [String: String] =
                            [   "SPChatRatingInputSliderViewCell" : "SPChatRatingInputSliderViewCellIdentifier",
                                "SPChatRatingInputThumbsViewCell" :   "SPChatRatingInputThumbsViewCellIdentifier"];
    
    var ratingModel : RatingInputModel?;
    let ratingCellHeight : CGFloat = 55.0;

    init(ratingModel : RatingInputModel) {
        super.init(nibName: "SPChatRatingInputViewController", bundle: nil);
        self.ratingModel = ratingModel;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func getMaxNumberOfRatingCells() -> Int {
        return min(3, ratingModel!.metrics!.count);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableViewHeight.constant = CGFloat(getMaxNumberOfRatingCells()) * ratingCellHeight;
        if ratingModel!.metrics!.count == 0 {
            self.tableViewRating.hidden = true;
        }
        self.tableViewRating.allowsSelection = false;
        self.tableViewRating.rowHeight = self.ratingCellHeight;
        self.registerCellIdentifiers();
        self.buttonSubmit.enabled = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getHeight() -> CGFloat {
        // -1 because in the interface builder is already added a subcell
        return self.view.frame.size.height + CGFloat(getMaxNumberOfRatingCells() - 1) * ratingCellHeight;
    }

    @IBAction func buttonSubmitAction(sender: AnyObject) {
        if(ratingModel?.satisfiedMetrics() == false) {
            SPUtils.displayErrorAlertController("Please fill in all the required feedbacks!", viewController: self);
            return;
        }
        if self.fulfilledStatus == SPChatBaseInputStatus.WAIT {
            SPUtils.displayAlertController("Info", message: "You must listen to all the audios to submit your rating", viewController: self);
            return;
        }
        
        self.buttonSubmit.enabled = false;
        
        if(self.chatPageDelegate != nil) {
            self.chatPageDelegate?.didAddRating(self.ratingModel!);
            self.continueCurrentGame();
            // save the current RatingInputModel to the game state array
            self.chatPageDelegate?.addUserInput(self.ratingModel!);
        }
    }
    
    // MARK : SPChatRatingInputViewCellProtocol
    func didAddScoreOnCell(score: Float, cellIndex: Int) {
        self.ratingModel?.metrics![cellIndex].rating = score;
        self.ratingModel?.metrics![cellIndex].ratingSatisfied = true;
        if self.ratingModel?.satisfiedMetrics() == true {
            self.buttonSubmit.enabled = true;
        }
    }
    func getLabelByRating(cellIndex: Int) -> String {
        if self.ratingModel != nil {
            return self.ratingModel!.metrics![cellIndex].getLabelByRating();
        }
        return "";
    }
    func getAllLabels(cellIndex: Int) -> [String] {
        if self.ratingModel != nil {
            return self.ratingModel!.metrics![cellIndex].labels;
        }
        return [];
    }
}
