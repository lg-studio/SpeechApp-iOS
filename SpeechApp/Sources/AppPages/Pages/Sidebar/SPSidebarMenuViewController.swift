//
//  SPSidebarMenuViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 15/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AsyncImageView

class SPSidebarMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FailedRequestViewProtocol {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var leadingEdgeConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewProfilePicture: UIView!
    @IBOutlet weak var imageProfilePicture: AsyncImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var sidebarDelegate : SPMainContainerViewControllerSidebarVCProtocol?;
    
    var userDetailsModel : UserDetailsModel?;
    var sideBarModel : SPSidebarMenuModel?;
    weak var failedRequestView : FailedRequestView?;
    
    init() {
        super.init(nibName: "SPSidebarMenuViewController", bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewProfilePicture.setRoundCorners();
        self.reloadTopProfileViewData();
        sideBarModel = SPSidebarMenuModel();
        self.tableView.registerNib(UINib(nibName: "SPSidebarItemTabeViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPSidebarItemTabeViewCellItentifier");
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = SPSidebarItemTabeViewCell.estimatedCellHeight;
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
    }
    
    func reloadTopProfileViewData() {
        self.userDetailsModel = UserDetailsModel.loadUserDetailsModel();
        self.imageProfilePicture.imageURL = NSURL(string: self.userDetailsModel!.imageURL!);
        self.labelName.text = self.userDetailsModel?.getName();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.getSidebarItems();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.leadingEdgeConstraint.constant = 0.2 * self.view.bounds.size.width;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSidebarItems() {
        if self.sideBarModel?.inited == true {
            return;
        }
        self.sideBarModel?.getSidebarItems(self.backgroundView, onFinished : {
            [weak self] in
            self?.reloadSidebarMenu();
        });
    }
    func reloadSidebarMenu() {
        if self.sideBarModel?.inited == true {
            self.failedRequestView?.removeFromSuperview();
            self.failedRequestView = nil;
            self.tableView.reloadData();
        }
        else {
            self.failedRequestView = FailedRequestView.addFailedRequestView(self.backgroundView, refreshDelegate: self);
            self.failedRequestView?.labelError.textColor = UIColor.whiteColor();
        }
    }
    // MARK : FailedRequestViewProtocol
    func refreshCurrentRequest() {
        self.failedRequestView?.removeFromSuperview();
        self.failedRequestView = nil;
        self.getSidebarItems();
    }
    
    // table view functions
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideBarModel!.items.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : SPSidebarItemTabeViewCell = tableView.dequeueReusableCellWithIdentifier("SPSidebarItemTabeViewCellItentifier", forIndexPath:indexPath) as! SPSidebarItemTabeViewCell;
        var item = self.sideBarModel!.items[indexPath.row];
        cell.itemName.text = item.name;
        if indexPath.row == self.sideBarModel!.selectedIndex {
            tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None);
        }
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == self.sideBarModel!.selectedIndex) {
            self.sidebarDelegate?.showCenterPanel();
        }
        else {
            self.sideBarModel!.selectedIndex = indexPath.row;
            self.handleAction();
        }
    }
    
}
