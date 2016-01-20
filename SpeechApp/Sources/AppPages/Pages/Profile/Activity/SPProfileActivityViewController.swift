//
//  SPProfileActivityViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPProfileActivityViewController: SPBaseLazyLoadingViewController {
    @IBOutlet weak var viewBackground: UIView!
    weak var containerDelegate : SPMainProfileContainerViewControllerContainerProtocol?;
    
    init() {
        super.init(nibName: "SPProfileActivityViewController", serviceName: "ProfileActivities");
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewBackground.setRoundCorners();
        
        self.tableView.registerNib(UINib(nibName: "SPProfileActivityTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPProfileActivityTableViewCellIdentifier");
    }
    
    func getPageTitle() -> String {
        return "Activity";
    }
    
    override func buildTableViewCellAtIndex(indexPath : NSIndexPath, forDataObject dataObject : NSObject) -> UITableViewCell {
        if let activityModel = dataObject as? SPProfileActivityModel {
            var activityCell : SPProfileActivityTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPProfileActivityTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileActivityTableViewCell;
            activityCell.activityModel = activityModel;
            activityCell.reloadCell();
            return activityCell;
        }
        return UITableViewCell();
    }
    override func getEstimatedHeightForObject(dataObject : NSObject) -> CGFloat {
        if let activityModel = dataObject as? SPProfileActivityModel {
            return activityModel.estimatedHeight;
        }
        return 44.0;
    }
    
    override func createPageObjectArrayFromDictionary(dataDict : NSDictionary) -> [NSObject] {
        return SPProfileActivityModel.createActivitiesArrayFromDictionary(dataDict);
    }
    override func didSelectDataObject(dataObject : NSObject) {
        if let activityModel = dataObject as? SPProfileActivityModel {
            if activityModel.taskId != nil {
                self.containerDelegate?.didTapTaskInProfileActivity(activityModel.taskId!, taskName: activityModel.taskName);
            }
        }
    }
    
    // build the header of the table view
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            return UIView(frame: CGRectZero);
        }
        var headerView = SPProfileActivityHeaderView();
        headerView.view.setRoundCorners();
        return headerView;
    }
}
