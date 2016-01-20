//
//  SPChatImageMultipleChoiceInputViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 07/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPChatImageMultipleChoiceInputViewController: SPChatMultipleChoiceInputViewController {

    @IBOutlet weak var answer1Image: AsyncImageView!;
    @IBOutlet weak var answer2Image: AsyncImageView!;
    @IBOutlet weak var answer3Image: AsyncImageView!;
    @IBOutlet weak var answer4Image: AsyncImageView!;
    
    
    init(multipleChoiceModel : MultipleChoiceModel) {
        super.init(nibName: "SPChatImageMultipleChoiceInputViewController", bundle: nil);
        self.multipleChoiceModel = multipleChoiceModel;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var imagesArray = [answer1Image, answer2Image, answer3Image, answer4Image];
        
        var i = 0;
        for imageView in imagesArray {
            if let imageModel = self.multipleChoiceModel?.choices?[i] as? SingleImageChoiceModel {
                imageView.imageURL = NSURL(string: imageModel.choiceImageURL);
                imageView.contentMode = .ScaleAspectFit;
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
