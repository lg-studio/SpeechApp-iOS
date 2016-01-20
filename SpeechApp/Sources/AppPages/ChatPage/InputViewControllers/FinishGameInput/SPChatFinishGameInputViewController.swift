//
//  SPChatFinishGameInputViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 03/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatFinishGameInputViewController: SPChatBaseInputViewController {
    @IBOutlet weak var buttonSubmit: UIButton!
    
    init() {
        super.init(nibName: "SPChatFinishGameInputViewController", bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func getHeight() -> CGFloat {
        return self.view.frame.height;
    }

    @IBAction func buttonSubmitAction(sender: AnyObject) {
        if(self.chatPageDelegate != nil) {
            self.chatPageDelegate!.finishCurrentGame();
            // only finish a game once
            self.buttonSubmit.enabled = false;
        }
    }
}
