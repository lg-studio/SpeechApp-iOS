//
//  SPChatPageViewControllerAnimationsExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 14/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPChatPageViewController {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var boxModel = self.chatFactory?.getBoxModelAtIndex(indexPath);
        if(boxModel?.wasAnimated == false && self.chatMode == .FULL) {
            
            // Load
            let soundURL = NSBundle.mainBundle().URLForResource(self.getSoundName(boxModel), withExtension: "mp3");
            var mySound: SystemSoundID = 0;
            AudioServicesCreateSystemSoundID(soundURL, &mySound);
            // Play
            AudioServicesPlaySystemSound(mySound);
            
            // Define the initial state (Before the animation)
            let translation = CATransform3DTranslate(CATransform3DIdentity, self.getTranslation(boxModel), 100, 0);
            let fullTransform = CATransform3DScale(translation, 0.001, 0.001, 0.001);
            
            cell.layer.transform = fullTransform;
            let view = cell.contentView;
            view.layer.opacity = 0.1;
            
            UIView.animateWithDuration(0.4, animations: {
                cell.layer.transform = CATransform3DIdentity;
                view.layer.opacity = 1;
            });
            
            boxModel?.wasAnimated = true;
        }
    }
    
    private func getSoundName(boxModel : BaseBoxModel?) -> String {
        if boxModel?.personalMesage == true {
            return "SentMessage";
        }
        return "ReceivedMessage";
    }
    
    private func getTranslation(boxModel : BaseBoxModel?) -> CGFloat {
        if boxModel?.personalMesage == true {
            return UIScreen.mainScreen().bounds.width * 2;
        }
        return -UIScreen.mainScreen().bounds.width;
    }
    
}