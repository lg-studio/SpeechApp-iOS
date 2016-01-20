//
//  SPProfileTasksViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileTasksViewController: SPBaseProfileViewController, FailedRequestViewProtocol {
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var tableView: UITableView!;
    
    var taskContainerModel : SPProfileTaskContainerModel;
    weak var failedRequestView : FailedRequestView?;
    
    init() {
        self.taskContainerModel = SPProfileTaskContainerModel();
        super.init(nibName: "SPProfileTasksViewController", bundle: nil);
    }
    required init(coder aDecoder: NSCoder) {
        self.taskContainerModel = SPProfileTaskContainerModel();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewBackground.setRoundCorners();
        self.tableView.registerNib(UINib(nibName: "SPProfileTasksTaskEntryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileTasksTaskEntryTableViewCellIdentifier");
        self.tableView.registerNib(UINib(nibName: "SPProfileTasksCertificateEntryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileTasksCertificateEntryTableViewCellIdentifier");
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 65;
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.getProfileTasks();
    }

    override func getPageTitle() -> String {
        return "Tasks";
    }
    func getProfileTasks() {
        if self.taskContainerModel.inited == true {
            return;
        }
        // get the task navigation model from the server
        self.taskContainerModel.getProfileTasks(self.view, onFinished: {
            [weak self] in
            self?.reloadPage();
        });
    }
    func reloadPage() {
        if self.taskContainerModel.inited == true {
            self.tableView.reloadData();
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
        }
    }
    
    // MARK : FailedRequestViewProtocol
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.getProfileTasks();
    }

}
