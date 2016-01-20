//
//  SPTaskTemplatesPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPTaskTemplatesPageViewController: SPBaseTaskPageViewController {
    @IBOutlet weak var labelTaskTemplatesTitle: UILabel!;
    
    var topicModel   : SPTopicModel?;
    
    init(topicModel : SPTopicModel) {
        super.init(nibName: "SPTaskTemplatesPageViewController", bundle: nil);
        
        self.topicModel = topicModel;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initNavBar(self.topicModel!.name);
        self.labelTaskTemplatesTitle.text = "Choose an Exercise";
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        // get the navigation tree model
        self.reloadNavigationTree();
    }
    
    // reload table and pageControl
    func reloadNavigationTree() {
        self.pageControl.numberOfPages = self.topicModel!.taskTemplates.count;
        self.horizontalTableView?.tableView.reloadData();
    }
    
    override func registerCells() {
        self.horizontalTableView!.tableView.registerNib(UINib(nibName: "SPTaskTemplateTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPTaskTemplateTableViewCellIdentifier");
    }
    

    @IBAction func didTapPageControl(sender: AnyObject) {
        self.horizontalTableView?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.pageControl.currentPage, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true);
    }

}
