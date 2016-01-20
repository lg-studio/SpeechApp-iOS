//
//  SPTaskCategoriesPageViewControllerTableViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPTaskCategoriesPageViewController : PTETableViewDelegate {

    // MARK : PTETableViewDelegate delegates
    override func tableView(horizontalTableView: PTEHorizontalTableView!, numberOfRowsInSection section: Int) -> Int {
        return self.taskNavigationTreeModel!.topics.count;
    }
    
    override func tableView(horizontalTableView: PTEHorizontalTableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : SPTaskItemTableViewCell = horizontalTableView.tableView.dequeueReusableCellWithIdentifier("SPTaskItemTableViewCellIdentifier", forIndexPath:indexPath) as! SPTaskItemTableViewCell;
        cell.topicModel = self.taskNavigationTreeModel!.topics[indexPath.row];
        cell.reloadCell();
        return cell;
    }
    
    func tableView(horizontalTableView: PTEHorizontalTableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        horizontalTableView.tableView.deselectRowAtIndexPath(indexPath, animated: false);
        self.openTopic(self.taskNavigationTreeModel!.topics[indexPath.row]);
    }
    
    func tableView(horizontalTableView: PTEHorizontalTableView!, didScrollToPageIndex index: Int) {
        if index >= 0 && index < self.taskNavigationTreeModel!.topics.count {
            self.pageControl.currentPage = index;
        }
    }
}