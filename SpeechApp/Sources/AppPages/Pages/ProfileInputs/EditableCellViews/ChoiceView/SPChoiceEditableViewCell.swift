//
//  CPChoiceEditableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChoiceEditableViewCell: SPBaseEditableViewCell {
    @IBOutlet weak var bottomView: UIView!;
    @IBOutlet weak var textField: SPChoiceEdgedTextField!;
    @IBOutlet weak var viewBottomChoice: UIView!;
    
    override func initCell() {
        self.bottomView.setRoundCorners();
        self.bottomView.setDefaultMarginColor();
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("didTapBottomView:"));
        self.viewBottomChoice.addGestureRecognizer(tap);
    }
    
    func didTapBottomView(sender : UIView) {
        self.textField.becomeFirstResponder();
    }
    
    override func reloadCell() {
        super.reloadCell();
        
        self.textField.placeholder = self.profileEntry?.displayName;
        if self.profileEntry?.value != nil {
            self.textField.text = SPUtils.convertAnyObjectToString(self.profileEntry!.value!);
        }
        else {
            self.textField.text = "";
        }
        
        self.textField.inputView = self.profileEntry!.pickerView!;
        self.selectDefaultRowIfApplicable();
        self.setErrorMarginIfNecessary();
    }
    func setErrorMarginIfNecessary() {
        if self.profileEntry?.required == true && self.profileEntry?.displayConstraintsErrors == true && self.profileEntry?.isValid() == false {
            self.bottomView.setRedMarginColor();
        }
        else {
            self.bottomView.setDefaultMarginColor();
        }
    }
    
    private func selectDefaultRowIfApplicable() {
        var valueToSelect : AnyObject?;
        if self.profileEntry?.value != nil {
            valueToSelect = self.profileEntry?.value;
        }
        else if self.profileEntry?.choiceGeneratorModel?.defaultValue != nil {
            valueToSelect = self.profileEntry?.choiceGeneratorModel?.defaultValue;
        }
        
        
        if self.profileEntry?.choiceGeneratorModel != nil && valueToSelect != nil {
            let genModel = self.profileEntry!.choiceGeneratorModel!;
            
            var index = 0;
            for option in genModel.values {
                if SPUtils.compareObjects(option, obj2: valueToSelect!) {
                    self.profileEntry?.pickerView?.selectRow(index, inComponent: 0, animated: false);
                    break;
                }
                index++;
            }
        }
    }
    override func getHeight() -> CGFloat {
        return 65.0;
    }
}