//
//  SPMultipleChoiceCategoryViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 22/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPMultipleChoiceCategoryViewController: SPMultipleChoiceBaseViewController, FailedRequestViewProtocol {
    @IBOutlet weak var labelDisplayText: UILabel!;
    
    var choiceCollectionModel : SPChoiceCollectionModel?;
    weak var failedRequestView : FailedRequestView?;
    
    required init(taskTemplate : SPTaskTemplateModel) {
        self.choiceCollectionModel = SPChoiceCollectionModel(taskTemplateId: taskTemplate.taskId);
        super.init(taskTemplate: taskTemplate, nibName: "SPMultipleChoiceCategoryViewController");
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.labelDisplayText.text = "";
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        // get the navigation tree model
        self.getMultipleChoiceOptions();
    }
    
    func getMultipleChoiceOptions() {
        if self.choiceCollectionModel?.inited == true {
            return;
        }
        // get the task navigation model from the server
        self.choiceCollectionModel?.getMultipleChoiceOptions(self.view, onFinished: {
            [weak self] in
            self?.reloadPage();
            });
    }
    
    func reloadPage() {
        if self.choiceCollectionModel?.inited == true {
            self.failedRequestView?.removeFromSuperview();
            self.failedRequestView = nil;
            self.collectionView.reloadData();
            self.labelDisplayText.text = self.choiceCollectionModel?.displayText;
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
        }
    }
    func refreshCurrentRequest() {
        self.getMultipleChoiceOptions();
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.choiceCollectionModel!.options.count;
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.getCellFromItemModel(collectionView, indexPath: indexPath, itemModel: self.choiceCollectionModel!.options[indexPath.row]);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false);
        let itemModel = self.choiceCollectionModel!.options[indexPath.row];
        
        // open the subsections
        if itemModel.innerOptions.count > 0 {
            var viewCtrl = SPMultipleChoiceSubcategoryViewController(taskTemplate: self.taskTemplate!, itemModel: itemModel, displayText : self.choiceCollectionModel!.displayText);
            viewCtrl.panelContainerDelegate = self.panelContainerDelegate;
            self.navigationController?.pushViewController(viewCtrl, animated: true);
        }
        else {
            self.openChatPage(itemModel.itemId, choiceSuboptionId : nil);
        }
    }

}
