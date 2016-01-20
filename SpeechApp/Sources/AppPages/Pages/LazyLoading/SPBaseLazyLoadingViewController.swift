//
//  SPBaseLazyLoadingViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 14/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPBaseLazyLoadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FailedRequestViewProtocol {
    
    @IBOutlet weak var labelNoDataAvailable: UILabel!;
    @IBOutlet weak var tableView: UITableView!;
    
    var serviceName : String = "";
    private let count : Int = 20;
    private let maxObjects : Int = 6000;
    
    private var offset : Int = 0;
    private var pageLoading : Bool;
    private var loadingFinished : Bool = false;
    
    var pageObjects : [NSObject] = [];
    
    weak var failedRequestView : FailedRequestView?;
    
    init(nibName: String, serviceName : String) {
        self.serviceName = serviceName;
        self.pageLoading = false;
        super.init(nibName: nibName, bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        self.pageLoading = false;
        super.init(coder : aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 44;
        
        self.tableView.registerNib(UINib(nibName: "SPLoadingTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPLoadingTableViewCellIdentifier");
        
        self.loadPage();
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // load the page when the last row of the page has been accessed
            if indexPath.row == self.pageObjects.count - 1 {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    self.loadPage();
                });
            }
            return self.buildTableViewCellAtIndex(indexPath, forDataObject: self.pageObjects[indexPath.row]);
        }
        else {
            var loadingCell : SPLoadingTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPLoadingTableViewCellIdentifier", forIndexPath:indexPath) as! SPLoadingTableViewCell;
            loadingCell.activityIndicatorView.startAnimating();
            return loadingCell;
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.pageObjects.count;
        case 1:
            return 1;
        default:
            return 0;
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.pageLoading == true {
            return 2;
        }
        return 1;
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.getEstimatedHeightForObject(self.pageObjects[indexPath.row]);
        }
        return 44.0;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        if (indexPath.section > 0) {
            return;
        }
        self.didSelectDataObject(self.pageObjects[indexPath.row]);
    }
    
    func didSelectDataObject(dataObject : NSObject) {
        preconditionFailure("This method must be overridden!") ;
    }
    func getEstimatedHeightForObject(dataObject : NSObject) -> CGFloat {
        preconditionFailure("This method must be overridden!") ;
    }
    func buildTableViewCellAtIndex(indexPath : NSIndexPath, forDataObject dataObject : NSObject) -> UITableViewCell {
        preconditionFailure("This method must be overridden!") ;
    }
    
    func reloadPage() {
        lock(self) {
            self.failedRequestView?.removeFromSuperview();
            self.failedRequestView = nil;
            
            self.pageLoading = true;
            self.loadingFinished = false;
            self.pageObjects.removeAll();
            self.offset = 0;
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData();
            });
            
            self.getPageObjectForCurrentSlot();
        }
    }
    
    private func loadPage() {
        lock(self) {
            if self.pageLoading == true || self.loadingFinished == true {
                return;
            }
            self.pageLoading = true;
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData();
            });
            
            self.getPageObjectForCurrentSlot();
        }
    }
    
    func buildMethodUrl(offset : Int, count : Int) -> String {
        return String(format : "%@/%d/%d", self.serviceName, self.offset, self.count);
    }
    
    private func getPageObjectForCurrentSlot() {
        var httpUtilities = THAHttpUtilities.getHttpUtilities();
        httpUtilities.get(self.buildMethodUrl(self.offset, count: self.count), parameters: nil,
            onError: {[weak self] (statusCode: THAHttpStatus, status : String) in
                self?.didFailToLoadObjects();
            },
            onSuccess: {[weak self] (data : NSObject) in
                if let dataDict = data as? NSDictionary {
                    self?.didLoadPageObjects(self?.createPageObjectArrayFromDictionary(dataDict));
                }
            }
        );
    }
    
    func didFailToLoadObjects() {
        lock (self) {
            self.pageLoading = false;
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData();
                if self.pageObjects.count == 0 {
                    self.failedRequestView = FailedRequestView.addFailedRequestView(self.view, refreshDelegate: self);
                }
            });
        }
    }
    func didLoadPageObjects(objects : [NSObject]?) {
        lock(self) {
            if objects == nil {
                return;
            }
            
            self.pageObjects += objects!;
            self.offset = self.pageObjects.count;
            
            if objects?.count < self.count || self.pageObjects.count > self.maxObjects {
                self.loadingFinished = true;
            }
            self.pageLoading = false;
        
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData();
                
                if self.pageObjects.count == 0 {
                    self.tableView.hidden = true;
                    self.labelNoDataAvailable.hidden = false;
                }
                
            });
        }
    }
    // MARK : FailedRequestViewProtocol
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.loadPage();
    }
    
    func createPageObjectArrayFromDictionary(dataDict : NSDictionary) -> [NSObject] {
        preconditionFailure("This method must be overridden!") ;
    }

}
