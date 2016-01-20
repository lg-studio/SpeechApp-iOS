//
//  SPChatPageViewControllerChatTableExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 08/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

// protocol that communicates with the output cells
protocol SPChatPageViewControllerChatTableProtocol : class {
    func openFullScreenImage(imageURL : String);
}

extension SPChatPageViewController : SPChatPageViewControllerChatTableProtocol {
    func openFullScreenImage(imageURL : String) {
        var fullScreenImageVC = FullScreenImageViewController(imageURL: imageURL);
        self.addChildViewControllerOnSubview(fullScreenImageVC, subview: self.view);
    }
}