//
//  ViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

class SPMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initNavBar("Main Page");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {[weak self] () -> Void in
//            let chatPageVC = SPChatPageViewController();
//            let chatPageVC = SPMainContainerViewController();
//            self?.navigationController?.pushViewController(chatPageVC, animated: true);
        };

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnChatPageAction(sender: AnyObject) {
        let chatPageVC = SPChatPageViewController(taskTemplateType: .RegularTask,taskTemplateId: "552d077f00c97637a01c120b", taskName: "Chat Example", optionId: nil, subOptionId: nil);
        self.navigationController?.pushViewController(chatPageVC, animated: true);
    }
    @IBAction func btnCertificatesPageAction(sender: AnyObject) {
        let chatPageVC = SPMainContainerViewController();
        self.navigationController?.pushViewController(chatPageVC, animated: true);
    }
}

