//
//  SPMultipleChoiceBaseViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPMultipleChoiceBaseViewController: SPContainerCenterUIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!;
    
    var taskTemplate   : SPTaskTemplateModel?;
    
    init(taskTemplate : SPTaskTemplateModel, nibName : String) {
        super.init(nibName: nibName, bundle: nil);
        self.taskTemplate = taskTemplate;
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initNavBar(self.taskTemplate!.name);
        self.registerCellIdentifiers();
    }
    private func registerCellIdentifiers() {
        self.collectionView.registerNib(UINib(nibName: "SPTextChoiceCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "SPTextChoiceCollectionViewCellIdentifier");
        self.collectionView.registerNib(UINib(nibName: "SPImageChoiceCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "SPImageChoiceCollectionViewCellIdentifier");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell();
    }
    // MARK : UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    
    func getCellFromItemModel (collectionView: UICollectionView, indexPath: NSIndexPath, itemModel : SPChoiceItemModel) -> SPBaseChoiceCollectionViewCell {
        switch itemModel.itemType {
        case .Image:
            var imgCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SPImageChoiceCollectionViewCellIdentifier", forIndexPath: indexPath) as!
            SPImageChoiceCollectionViewCell;
            imgCell.imageViewCell.image = nil;
            imgCell.imageViewCell.imageURL = nil;
            
            if let itemImg = itemModel.item as? SPChoiceImageItemModel {
                imgCell.imageViewCell.imageURL = NSURL(string: itemImg.imageUrl);
            }
            return imgCell;
        case .Text:
            var textCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("SPTextChoiceCollectionViewCellIdentifier", forIndexPath: indexPath) as!
            SPTextChoiceCollectionViewCell;
            if let itemText = itemModel.item as? SPChoiceTextItemModel {
                textCell.labelTextChoice.text = itemText.text;
            }
            return textCell;
        }
    }
    
    // open the chat page
    func openChatPage(choiceOptionId : Int, choiceSuboptionId : Int?) {
        let chatPageVC = SPChatPageViewController(taskTemplateType: self.taskTemplate!.taskType,taskTemplateId: self.taskTemplate!.taskId, taskName: self.taskTemplate!.name, optionId : choiceOptionId, subOptionId : choiceSuboptionId);
        self.navigationController?.pushViewController(chatPageVC, animated: true);
    }
}
