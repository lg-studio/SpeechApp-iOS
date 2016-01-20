//
//  SPNavBarCustomization.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 10/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPNavBarCustomizer {
    // function called from the AppDelegate to initialize the appearance of the nav bar
    static func initNavBar() {
        var navigationBarAppearace = UINavigationBar.appearance();
        
        navigationBarAppearace.barTintColor = UIColor(red : 37/255.0, green: 102/255.0, blue: 4/255.0, alpha: 1.0);
        navigationBarAppearace.tintColor = UIColor.whiteColor();
        let font = UIFont(name: "HelveticaNeue", size: 20);
        if let font = font {
            navigationBarAppearace.titleTextAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.whiteColor()];
        }
        
        let backImg: UIImage = UIImage(named: "BackLeftArrow")!;
        navigationBarAppearace.backIndicatorImage = backImg;
        navigationBarAppearace.backIndicatorTransitionMaskImage = backImg;
        
    }
    
    
}
