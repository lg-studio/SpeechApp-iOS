//
//  SPProfileTasksViewControllerTableViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension SPProfileTasksViewController : UITableViewDataSource, UITableViewDelegate {
    // MARK : tableView delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.taskContainerModel.tasksArray.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskGradeModel : SPProfileTaskGradeModel = self.taskContainerModel.tasksArray[section];
        if taskGradeModel.expanded {
            return 1 + taskGradeModel.certificates.count;
        }
        return 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let taskGradeModel : SPProfileTaskGradeModel = self.taskContainerModel.tasksArray[indexPath.section];
        
        if indexPath.row == 0 {
            var taskCell : SPProfileTasksTaskEntryTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPProfileTasksTaskEntryTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileTasksTaskEntryTableViewCell;
            taskCell.taskGradeModel = taskGradeModel;
            taskCell.reloadCell();
            return taskCell;
        }
        else {
            var certificateCell : SPProfileTasksCertificateEntryTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPProfileTasksCertificateEntryTableViewCellIdentifier", forIndexPath:indexPath) as! SPProfileTasksCertificateEntryTableViewCell;
            certificateCell.certificateModel = taskGradeModel.certificates[indexPath.row - 1];
            certificateCell.reloadCell();
            return certificateCell;
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false);
        if indexPath.row == 0 {
            let taskGradeModel : SPProfileTaskGradeModel = self.taskContainerModel.tasksArray[indexPath.section];
            if taskGradeModel.isExpandable() {
                taskGradeModel.expanded = !taskGradeModel.expanded;
                tableView.reloadData();
            }
        }
    }
}
