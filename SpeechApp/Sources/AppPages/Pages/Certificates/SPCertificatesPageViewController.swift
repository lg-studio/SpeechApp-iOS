//
//  SPCertificatesPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPCertificatesPageViewController: SPContainerCenterUIViewController, UITableViewDataSource, UITableViewDelegate, FailedRequestViewProtocol {
    @IBOutlet weak var certificatesTableView: UITableView!;
    
    var certificatesModel : SPCertificateContainerModel?;
    weak var failedRequestView : FailedRequestView?;
    
    init() {
        super.init(nibName: "SPCertificatesPageViewController", bundle: nil);
        // register notifications
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        self.certificatesModel = SPCertificateContainerModel();
        self.initNavBar("SpeechApp");
        self.certificatesTableView.registerNib(UINib(nibName: "SPCertificateItemTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPCertificateItemTableViewCellIdentifier");
        self.certificatesTableView.registerNib(UINib(nibName: "SPSubcertificateItemTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPSubcertificateItemTableViewCellIdentifier");
        
        self.certificatesTableView.tableFooterView = UIView(frame: CGRectZero);
        self.certificatesTableView.rowHeight = UITableViewAutomaticDimension;
        self.certificatesTableView.estimatedRowHeight = 53.0;
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.getCertificates();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    func getCertificates() {
        if self.certificatesModel?.inited == true {
            return;
        }
        
        self.certificatesModel?.getCertificates(self.view, onFinished: {
            [weak self] in
            self?.reloadCertificates();
        });
    }
    func reloadCertificates() {
        if self.certificatesModel?.inited == true {
            self.failedRequestView?.removeFromSuperview();
            self.failedRequestView = nil;
            self.certificatesTableView.reloadData();
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
        }
    }
    // MARK : FailedRequestViewProtocol
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.getCertificates();
    }
    
    // table view functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfCells();
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.getTableViewCellAtIndex(indexPath, tableView : tableView);
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        
        let objectModel = self.getModelAtIndex(indexPath.row);
        
        if let certificate = objectModel as? SPCertificateItemModel {
            if certificate.isExpandable() {
                certificate.expanded = !certificate.expanded;
                self.certificatesTableView.reloadData();
            }
            else {
                self.openTaskPage(certificate.categoryId, subcategoryId: nil, name : certificate.name);
            }
            
        }
        else if let subcertificate = objectModel as? SPCertificateSubcategoryItemModel {
            self.openTaskPage(subcertificate.categoryId, subcategoryId: subcertificate.subcategoryId, name : subcertificate.name);
        }
    }
    
    func openTaskPage(categoryId : String, subcategoryId : String?, name : String) {
        var taskCategoriesVC = SPTaskCategoriesPageViewController(categoryId: categoryId, subcategoryId: subcategoryId, name: name);
        taskCategoriesVC.panelContainerDelegate = self.panelContainerDelegate;
        self.navigationController?.pushViewController(taskCategoriesVC, animated: true);
    }
}
