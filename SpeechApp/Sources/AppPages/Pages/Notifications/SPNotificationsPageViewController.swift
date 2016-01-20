//
//  SPNotificationsPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 17/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPNotificationsPageViewController: SPBaseLazyLoadingViewController {
    weak var panelContainerDelegate: SPMainContainerViewControllerCenterVCProtocol?;
    
    var notificationUtils : SPNotificationUtilsModel = SPNotificationUtilsModel();
    
    init() {
        super.init(nibName: "SPNotificationsPageViewController", serviceName : "GetNotifications");
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initNavBar("Notifications");
        self.setSidebarIcon();
        self.tableView.registerNib(UINib(nibName: "SPNotificationEntryTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SPNotificationEntryTableViewCellIdentifier");
    }

    @IBAction func didTapSegmentedControl(sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            let notificationType = self.getNotificationModelTypeFromSegmentIndex(segmentedControl.selectedSegmentIndex);
            if notificationType != self.notificationUtils.currentNotificationType {
                self.notificationUtils.currentNotificationType = notificationType;
                self.reloadPage();
            }
        }
    }
    private func getNotificationModelTypeFromSegmentIndex(selectedIndex : Int) -> SPNotificationModelTypes? {
        switch selectedIndex {
        case 0:
            return nil;
        case 1:
            return .PLAIN_MESSAGE;
        case 2:
            return .SENT_FEEDBACK;
        case 3:
            return .RECEIVED_FEEDBACK;
        default:
            return nil;
        }
    }
    
    // MARK : methods from BaseLazyLoading
    override func buildMethodUrl(offset : Int, count : Int) -> String {
        var serviceName = String(format : "%@/%d/%d/", self.serviceName, offset, count);
        if notificationUtils.currentNotificationType != nil {
            serviceName = String(format : "%@%@", serviceName, notificationUtils.currentNotificationType!.rawValue);
        }
        return serviceName;
    }
    
    override func createPageObjectArrayFromDictionary(dataDict : NSDictionary) -> [NSObject] {
        return self.notificationUtils.createNotificationsArrayFromDictionary(dataDict);
    }
    override func didSelectDataObject(dataObject : NSObject) {
        if let notification = dataObject as? SPNotificationModel {
            if notification.readTimestamp == nil {
                notification.markAsRead();
                self.tableView.reloadData();
            }
            // open the chat if necessary
            self.openChatPageIfNecessary(notification);
        }
    }
    override func getEstimatedHeightForObject(dataObject : NSObject) -> CGFloat {
        if let notification = dataObject as? SPNotificationModel {
            if notification.estimatedHeight != nil {
                return notification.estimatedHeight!;
            }
        }
        return 65.0;
    }
    override func buildTableViewCellAtIndex(indexPath : NSIndexPath, forDataObject dataObject : NSObject) -> UITableViewCell {
        if let notification = dataObject as? SPNotificationModel {
            var notificationCell : SPNotificationEntryTableViewCell = tableView.dequeueReusableCellWithIdentifier("SPNotificationEntryTableViewCellIdentifier", forIndexPath:indexPath) as! SPNotificationEntryTableViewCell;
            notificationCell.notification = notification;
            notificationCell.reloadCell();
            return notificationCell;
        }
        return UITableViewCell();
    }
    
    // open the chat page from the tapping of a notification
    func openChatPageIfNecessary(notification : SPNotificationModel) {
        switch notification.notificationType {
        case .SENT_FEEDBACK:
            self.openChatPage(notification.taskModel);
            break;
        case .RECEIVED_FEEDBACK:
            self.openChatPage(notification.taskModel);
            break;
        default:
            break;
        }
    }
    
    private func openChatPage(notificationTaskModel : SPNotificationTaskModel?) {
        if notificationTaskModel == nil {
            return;
        }
        var chatPageVC = SPChatPageViewController(taskId : notificationTaskModel!.taskId, defaultNodeId : notificationTaskModel!.nodeId, taskName : "");
        self.navigationController?.pushViewController(chatPageVC, animated: true);
    }

}
