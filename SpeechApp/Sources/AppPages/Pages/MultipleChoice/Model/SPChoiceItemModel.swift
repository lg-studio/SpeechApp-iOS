//
//  SPChoiceItemModel.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit


enum SPChoiceItemModelType : String {
    case Text   =   "Text"
    case Image  =   "Image"
}

class SPChoiceItemModel: NSObject {
    var itemId      : Int;
    var itemType    : SPChoiceItemModelType;
    var item        : SPChoiceBaseItemModel;
    var innerOptions: [SPChoiceItemModel];
    
    init(inputDict : NSDictionary) {
        self.itemId = 0;
        if let itemId = inputDict.objectForKey("Id") as? Int {
            self.itemId = itemId;
        }
        
        self.itemType = .Text;
        if let itemType = inputDict.objectForKey("Type") as? String {
            switch itemType {
            case SPChoiceItemModelType.Text.rawValue:
                self.itemType = .Text;
                break;
            case SPChoiceItemModelType.Image.rawValue:
                self.itemType = .Image;
                break;
            default:
                break;
            }
        }
        
        if let propDict = inputDict.objectForKey("Properties") as? NSDictionary {
            switch self.itemType {
            case .Image:
                self.item = SPChoiceImageItemModel(inputDict: propDict);
                break;
            default:
                self.item = SPChoiceTextItemModel(inputDict: propDict);
                break;
            }
        }
        else {
            self.item = SPChoiceTextItemModel(inputDict: NSDictionary());
        }
        
        
        self.innerOptions = [];
        if let innerOptionsArray = inputDict.objectForKey("InnerOptions") as? NSArray {
            for innerOptionsData in innerOptionsArray {
                if let innerOptionsDict = innerOptionsData as? NSDictionary {
                    self.innerOptions.append(SPChoiceItemModel(inputDict: innerOptionsDict));
                }
            }
        }
        
        super.init();
    }
    override init() {
        self.itemId = 0;
        self.innerOptions = [];
        self.item = SPChoiceTextItemModel(inputDict: NSDictionary());
        self.itemType = .Text;
        super.init();
    }
}
