//
//  SPProfileFeedbackViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileFeedbackViewController: SPBaseProfileViewController, FailedRequestViewProtocol, UITableViewDataSource {
    @IBOutlet weak var viewBackground: UIView!;
    
    @IBOutlet weak var tableView: UITableView!
    weak var failedRequestView : FailedRequestView?;
    
    var profileStatisticsModel : ProfileFeedbackStatisticsModel;
    init() {
        self.profileStatisticsModel = ProfileFeedbackStatisticsModel();
        super.init(nibName: "SPProfileFeedbackViewController", bundle: nil);
    }
    required init(coder aDecoder: NSCoder) {
        self.profileStatisticsModel = ProfileFeedbackStatisticsModel();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewBackground.setRoundCorners();
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.registerNib(UINib(nibName: "SPBasicKeyValueTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPBasicKeyValueTableViewCellIdentifier");
        self.tableView.allowsSelection = false;
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        // get the navigation tree model
        self.getProfileStatistics();
    }
    
    func getProfileStatistics() {
        if self.profileStatisticsModel.inited == true {
            return;
        }
        // get the task navigation model from the server
        self.profileStatisticsModel.getProfileFeedbackStatistics(self.view, onFinished: {
            [weak self] in
            self?.reloadPage();
        });
    }
    func reloadPage() {
        if self.profileStatisticsModel.inited == true {
            self.failedRequestView?.removeFromSuperview();
            self.failedRequestView = nil;
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
        self.getProfileStatistics();
    }

    override func getPageTitle() -> String {
        return "Feedback";
    }
    
    
    // MARK : tableView delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileStatisticsModel.statistics.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let keyValueEntry : BasicKeyValueContainerModel = self.profileStatisticsModel.statistics[indexPath.row];
        var cell : SPBasicKeyValueTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPBasicKeyValueTableViewCellIdentifier", forIndexPath:indexPath) as! SPBasicKeyValueTableViewCell;
        cell.constraintLabel1Width.constant = (self.tableView.frame.size.width / 3) * 2;
        cell.labelFieldName.text = keyValueEntry.paramName;
        cell.labelFieldValue.text = keyValueEntry.paramValue;
        return cell;
    }
}
