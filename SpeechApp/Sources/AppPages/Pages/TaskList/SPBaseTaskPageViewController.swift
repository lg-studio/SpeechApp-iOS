//
//  SPBaseTaskPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseTaskPageViewController: SPContainerCenterUIViewController, PTETableViewDelegate {
    @IBOutlet weak var horizontalTableView: PTEHorizontalTableView!;
    @IBOutlet weak var pageControl: UIPageControl!;
    
    var defaultWidth : CGFloat = SPTaskItemTableViewCell.defaultWidth;
    
    var tableViewInited : Bool?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableViewInited = false;
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.initHorizontalTableView();
    }
    
    func initHorizontalTableView() {
        if self.tableViewInited == true {
            return;
        }
        
        // compute default width
        self.defaultWidth = self.horizontalTableView.frame.size.width - 60.0;
        // init the horizontal table view
        var tableView = UITableView();
        tableView.backgroundColor = UIColor.clearColor();
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.horizontalTableView.tableView = tableView;
        self.horizontalTableView.delegate = self;
        self.registerCells();
        
        self.tableViewInited = true;
    }

    func registerCells() {
    }
    
    // function to open the topic
    func openTopic(topicModel : SPTopicModel) {
        // if the topic has a single task open it
        if topicModel.hasSingleTask() {
            self.openTask(topicModel.getFirstTask());
        }
        // if there are multiple tasks, open the task templates page
        else {
            var taskTemplatesVC = SPTaskTemplatesPageViewController(topicModel: topicModel);
            taskTemplatesVC.panelContainerDelegate = self.panelContainerDelegate;
            self.navigationController?.pushViewController(taskTemplatesVC, animated: true);
        }
    }
    // function to open the task
    func openTask(taskTemplate : SPTaskTemplateModel) {
        switch taskTemplate.taskType {
        case .MultipleChoiceTask:
            var mcViewCtrl = SPMultipleChoiceCategoryViewController(taskTemplate: taskTemplate);
            mcViewCtrl.panelContainerDelegate = self.panelContainerDelegate;
            self.navigationController?.pushViewController(mcViewCtrl, animated: true);
            break;
        default:
            let chatPageVC = SPChatPageViewController(taskTemplateType: taskTemplate.taskType, taskTemplateId: taskTemplate.taskId, taskName: taskTemplate.name, optionId : nil, subOptionId : nil);
            self.navigationController?.pushViewController(chatPageVC, animated: true);
            break;
        }
    }
    
    // PTETableViewDelegate implementation : the first two methods need to be overriden in the child classes
    func tableView(horizontalTableView: PTEHorizontalTableView!, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    func tableView(horizontalTableView: PTEHorizontalTableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return UITableViewCell();
    }
    func tableView(horizontalTableView: PTEHorizontalTableView!, widthForCellAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return self.defaultWidth;
    }
    
}
