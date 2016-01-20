//
//  SPMultipleChoiceSubcategoryViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPMultipleChoiceSubcategoryViewController: SPMultipleChoiceBaseViewController {
    @IBOutlet weak var labelDisplayText: UILabel!;

    var itemModel : SPChoiceItemModel?;
    var displayText : String = "";
    
    required init(taskTemplate : SPTaskTemplateModel, itemModel : SPChoiceItemModel, displayText : String) {
        self.displayText = displayText;
        self.itemModel = itemModel;
        super.init(taskTemplate: taskTemplate, nibName: "SPMultipleChoiceSubcategoryViewController");
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.labelDisplayText.text = self.displayText;
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemModel!.innerOptions.count;
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.getCellFromItemModel(collectionView, indexPath: indexPath, itemModel: self.itemModel!.innerOptions[indexPath.row]);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false);
        let subitemModel = self.itemModel!.innerOptions[indexPath.row];
        self.openChatPage(self.itemModel!.itemId, choiceSuboptionId : subitemModel.itemId)
    }
}
