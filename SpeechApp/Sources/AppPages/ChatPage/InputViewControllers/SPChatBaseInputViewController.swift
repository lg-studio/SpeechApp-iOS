//
//  SPChatBaseInputViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 01/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

enum SPChatBaseInputStatus : String {
    case FULFILLED  =   "FULFILLED"
    case WAIT       =   "WAIT"
}

class SPChatBaseInputViewController: UIViewController {
    weak var chatPageDelegate : SPChatPageViewControllerInputViewProtocol?;
    
    var fulfilledStatus : SPChatBaseInputStatus = SPChatBaseInputStatus.WAIT;
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    func getHeight() -> CGFloat {
        return 0.0;
    }
    
    func setRoundCorners(viewIn : UIView) {
        viewIn.layer.cornerRadius = 4;
        viewIn.layer.masksToBounds = true;
    }

    
    func continueCurrentGame() {
        self.chatPageDelegate?.continueCurrentGame();
    }
    
    func setState(inputState : SPChatBaseInputStatus) {
        self.fulfilledStatus = inputState;
    }
    
}
