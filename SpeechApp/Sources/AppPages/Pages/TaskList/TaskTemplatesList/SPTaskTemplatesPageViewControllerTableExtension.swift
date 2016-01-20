//
//  SPTaskTemplatesPageViewControllerTableExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 20/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPTaskTemplatesPageViewController : PTETableViewDelegate {
    
    // MARK : PTETableViewDelegate delegates
    override func tableView(horizontalTableView: PTEHorizontalTableView!, numberOfRowsInSection section: Int) -> Int {
        return self.topicModel!.taskTemplates.count;
    }
    
    override func tableView(horizontalTableView: PTEHorizontalTableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : SPTaskTemplateTableViewCell = horizontalTableView.tableView.dequeueReusableCellWithIdentifier("SPTaskTemplateTableViewCellIdentifier", forIndexPath:indexPath) as! SPTaskTemplateTableViewCell;
        cell.taskTemplateModel = self.topicModel!.taskTemplates[indexPath.row];
        cell.reloadCell();
        return cell;
    }
    
    func tableView(horizontalTableView: PTEHorizontalTableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        horizontalTableView.tableView.deselectRowAtIndexPath(indexPath, animated: false);
        self.openTask(self.topicModel!.taskTemplates[indexPath.row]);
    }
    
    func tableView(horizontalTableView: PTEHorizontalTableView!, didScrollToPageIndex index: Int) {
        if index >= 0 && index < self.topicModel!.taskTemplates.count {
            self.pageControl.currentPage = index;
        }
    }
}