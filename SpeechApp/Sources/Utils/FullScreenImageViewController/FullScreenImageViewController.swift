//
//  FullScreenImageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 08/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class FullScreenImageViewController: UIViewController {
    var imageURL : String?;
    @IBOutlet weak var imageView: AsyncImageView!;
    
    
    init(imageURL : String) {
        super.init(nibName: "FullScreenImageViewController", bundle: nil);
        self.imageURL = imageURL;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.imageView.imageURL = NSURL(string: self.imageURL!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapOnView(sender: AnyObject) {
        self.removeSelfVCFromParentViewController();
    }

}
