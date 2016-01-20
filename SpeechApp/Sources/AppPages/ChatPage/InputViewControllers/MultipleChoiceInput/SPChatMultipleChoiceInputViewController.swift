//
//  SPChatMultipleChoiceInput.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatMultipleChoiceInputViewController: SPChatBaseInputViewController {
    
    @IBOutlet weak var answer1View: UIView!;
    @IBOutlet weak var answer2View: UIView!;
    @IBOutlet weak var answer3View: UIView!;
    @IBOutlet weak var answer4View: UIView!;
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var multipleChoiceModel : MultipleChoiceModel?;
    var answersViewArray = [];
    var didSubmitMC : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.answersViewArray = [answer1View, answer2View, answer3View, answer4View];
        
        var index = 0;
        for viewConverted in self.answersViewArray {
            if let view = viewConverted as? UIView {
                view.tag = index;
                self.setRoundCorners(view);
                var singleFingerTap = UITapGestureRecognizer(target: self, action: "didTapUIView:");
                view.addGestureRecognizer(singleFingerTap);
                index++;
            }
        }

        self.reloadViews();
    }
    
    func getSelectedColor() -> UIColor {
        return UIColor(red : 235/255.0, green: 253/255.0, blue: 216/255.0, alpha: 1.0);
    }
    func getDeselectedColor() -> UIColor {
        return UIColor.lightGrayColor();
    }
    func reloadViews() {
        for viewConverted in self.answersViewArray {
            if let view = viewConverted as? UIView {
                view.backgroundColor = self.getDeselectedColor();
            }
        }
        
        if(self.multipleChoiceModel?.isAnswerSelected() == false) {
            self.buttonSubmit.enabled = false;
        }
        else {
            self.buttonSubmit.enabled = true;
            if let viewConverted = self.answersViewArray[self.multipleChoiceModel!.selectedAnswerIndex!] as? UIView {
                viewConverted.backgroundColor = self.getSelectedColor();
            }
        }
    }
    
    func didTapUIView(sender : UIGestureRecognizer) {
        if self.didSubmitMC == true {
            return;
        }
        
        let selectedAnswerIndex = sender.view!.tag;
        // tap the same image => open the image in fullscreen
        if(selectedAnswerIndex == self.multipleChoiceModel?.selectedAnswerIndex && self.multipleChoiceModel?.inputType == InputModelTypes.MultipleChoicePictureInput.rawValue) {
            if(self.chatPageDelegate != nil) {
                self.chatPageDelegate?.openFullScreenImage(self.multipleChoiceModel!.getSelectedAnswerValue());
            }
        }
        self.multipleChoiceModel?.selectAnswer(selectedAnswerIndex);
        self.reloadViews();
    }
    
    @IBAction func buttonSubmitAction(sender: AnyObject) {
        if self.fulfilledStatus == SPChatBaseInputStatus.WAIT {
            SPUtils.displayAlertController("Info", message: "You must listen to all the audios to submit your answer", viewController: self);
            return;
        }
        
        if self.chatPageDelegate != nil {
            self.didSubmitMC = true;
            self.buttonSubmit.enabled = false;
            self.chatPageDelegate?.didAddMultipleChoiceResponse(self.multipleChoiceModel!);
            
            // save the current MultipleChoiceModel to the game state array
            self.chatPageDelegate?.addUserInput(self.multipleChoiceModel!);
        }
    }
}
