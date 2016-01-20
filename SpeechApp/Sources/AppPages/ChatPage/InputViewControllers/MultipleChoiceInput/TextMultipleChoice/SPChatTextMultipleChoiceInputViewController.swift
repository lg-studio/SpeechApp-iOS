//
//  SPChatTextMultipleChoiceInputViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatTextMultipleChoiceInputViewController: SPChatMultipleChoiceInputViewController {

    @IBOutlet weak var answer1Label: UILabel!;
    @IBOutlet weak var answer2Label: UILabel!;
    @IBOutlet weak var answer3Label: UILabel!;
    @IBOutlet weak var answer4Label: UILabel!;
    
    
    init(multipleChoiceModel : MultipleChoiceModel) {
        super.init(nibName: "SPChatTextMultipleChoiceInputViewController", bundle: nil);
        self.multipleChoiceModel = multipleChoiceModel;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var labelsArray = [answer1Label, answer2Label, answer3Label, answer4Label];
        
        var i = 0;
        for label in labelsArray {
            if let textModel = self.multipleChoiceModel?.choices?[i] as? SingleTextChoiceModel {
                label.text = textModel.choiceText;
                label.adjustsFontSizeToFitWidth = true;
            }
            i++;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func getHeight() -> CGFloat {
        return self.view.frame.height;
    }

}
