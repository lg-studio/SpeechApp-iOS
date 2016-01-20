//
//  SPProfileCompetencesViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileCompetencesViewController: SPBaseProfileViewController, FailedRequestViewProtocol {
    @IBOutlet weak var viewBackground: UIView!;
    @IBOutlet weak var tableView: UITableView!;
    
    var competencesModel : SPProfileCompentencesContainerModel;
    weak var failedRequestView : FailedRequestView?;
    
    init() {
        self.competencesModel = SPProfileCompentencesContainerModel();
        super.init(nibName: "SPProfileCompetencesViewController", bundle: nil);
    }
    required init(coder aDecoder: NSCoder) {
        self.competencesModel = SPProfileCompentencesContainerModel();
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewBackground.setRoundCorners();
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 65;
        
        self.tableView.registerNib(UINib(nibName: "SPProfileCompetenceHeaderTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileCompetenceHeaderTableViewCellIdentifier");
        self.tableView.registerNib(UINib(nibName: "SPProfileCompetenceCategoryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileCompetenceCategoryTableViewCellIdentifier");
        self.tableView.registerNib(UINib(nibName: "SPProfileSubcategoryWithHeaderTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileSubcategoryWithHeaderTableViewCellIdentifier");
        self.tableView.registerNib(UINib(nibName: "SPProfileSubcategoryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileSubcategoryTableViewCellIdentifier");
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.getCompetences();
    }

    override func getPageTitle() -> String {
        return "Competences";
    }
    
    func getCompetences() {
        if self.competencesModel.inited == true {
            return;
        }
        // get the task navigation model from the server
        self.competencesModel.getProfileCompetences(self.view, onFinished: {
            [weak self] in
            self?.reloadPage();
        });
    }
    func reloadPage() {
        if self.competencesModel.inited == true {
            self.tableView.reloadData();
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
        }
    }
    
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.getCompetences();
    }
}
