//
//  SPTaskCategoriesPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 19/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPTaskCategoriesPageViewController: SPBaseTaskPageViewController, FailedRequestViewProtocol {
    @IBOutlet weak var labelTaskCategoriesTitle: UILabel!;
    
    var categoryId : String = "";
    var subcategoryId : String?;
    var name : String = "";
    
    var taskNavigationTreeModel : SPTaskNavigationTreeModel?;
    weak var failedRequestView : FailedRequestView?;
    
    init(categoryId : String, subcategoryId : String?, name : String) {
        super.init(nibName: "SPTaskCategoriesPageViewController", bundle: nil);
        
        self.categoryId = categoryId;
        self.subcategoryId = subcategoryId;
        self.name = name;
        taskNavigationTreeModel = SPTaskNavigationTreeModel(categoryId: categoryId, subcategoryId: subcategoryId);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initNavBar(self.name);
        self.labelTaskCategoriesTitle.text = "Choose a Topic";
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        // get the navigation tree model
        self.getTaskNavigationTreeModel();
    }

    override func registerCells() {
        self.horizontalTableView!.tableView.registerNib(UINib(nibName: "SPTaskItemTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPTaskItemTableViewCellIdentifier");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTaskNavigationTreeModel() {
        if self.taskNavigationTreeModel?.inited == true {
            return;
        }
        // get the task navigation model from the server
        self.taskNavigationTreeModel?.getTaskNavigationTree(self.view, onFinished: {
            [weak self] in
            self?.reloadNavigationTree();
        });
    }
    // reload table and pageControl
    func reloadNavigationTree() {
        if self.taskNavigationTreeModel?.inited == true {
            self.failedRequestView?.removeFromSuperview();
            self.failedRequestView = nil;
            self.pageControl.numberOfPages = self.taskNavigationTreeModel!.topics.count;
            self.horizontalTableView?.tableView.reloadData();
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
        }
    }
    // MARK : FailedRequestViewProtocol
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.getTaskNavigationTreeModel();
    }
    
    @IBAction func didTapPageControl(sender: AnyObject) {
        if self.taskNavigationTreeModel?.inited == false {
            return;
        }
        self.horizontalTableView?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.pageControl.currentPage, inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: true);
    }
    
}
