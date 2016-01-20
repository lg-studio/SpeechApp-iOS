//
//  SPChatPageViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 23/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit
import TLYShyNavBar

enum SPChatPageViewControllerMode : String {
    case READ_ONLY  =   "READ_ONLY"
    case FULL       =   "FULL"
}

class SPChatPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SPChatFactoryProtocol {
    @IBOutlet weak var chatOutputTableView: UITableView!;
    @IBOutlet weak var chatInputView: UIView!;
    @IBOutlet weak var chatInputViewHeight: NSLayoutConstraint!;
    
    var chatFactory : SPChatFactory?;
    var lastRowIndex : Int?;
    
    var taskTemplateType : SPTaskTemplateType;
    var taskTemplateId : String;
    var taskName : String;
    var optionId : Int?;
    var subOptionId : Int?;
    
    var taskId : String;
    var defaultNodeId : Int;
    
    var chatMode : SPChatPageViewControllerMode;
    
    // init the chat in READ_ONLY mode
    init(taskId : String, defaultNodeId : Int?, taskName : String?) {
        self.taskTemplateType = SPTaskTemplateType.RegularTask;
        self.taskTemplateId = "";
        self.taskName = "";
        if taskName != nil {
            self.taskName = taskName!;
        }
        self.chatMode = .READ_ONLY;
        self.taskId = taskId;
        if defaultNodeId != nil {
            self.defaultNodeId = defaultNodeId!;
        }
        else {
            self.defaultNodeId = 0;
        }
        super.init(nibName: "SPChatPageViewController", bundle: nil);
    }
    
    // init the chat in FULL mode
    init(taskTemplateType : SPTaskTemplateType, var taskTemplateId : String, var taskName : String, optionId : Int?, subOptionId : Int?) {
        self.taskTemplateType = taskTemplateType;
        self.taskTemplateId = taskTemplateId;
        self.taskName = taskName;
        self.optionId = optionId;
        self.subOptionId = subOptionId;
        self.chatMode = .FULL;
        self.taskId = "";
        self.defaultNodeId = 0;
        super.init(nibName: "SPChatPageViewController", bundle: nil);
    }

    required init(coder aDecoder: NSCoder) {
        self.taskTemplateType = SPTaskTemplateType.RegularTask;
        self.taskTemplateId = "";
        self.taskName = "";
        self.chatMode = .FULL;
        self.taskId = "";
        self.defaultNodeId = 0;
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad();

        // Do any additional setup after loading the view.
        self.initNavBar(self.taskName);
        self.lastRowIndex = -1;
        
        chatOutputTableView.allowsSelection = false;
        chatOutputTableView.rowHeight = UITableViewAutomaticDimension;
        
        // setup scroll view navbar
        self.shyNavBarManager.scrollView = self.chatOutputTableView;
    }
    override func viewDidAppear(animated: Bool) {
        if self.chatFactory == nil {
            self.chatFactory = SPChatFactory(view: self.view, chatMode : self.chatMode, taskTemplateType : self.taskTemplateType, taskTemplateId: self.taskTemplateId, taskId : self.taskId, optionId: self.optionId, subOptionId : self.subOptionId);
            self.chatFactory?.registerCellIdentifiersOnTableView(self.chatOutputTableView);
            self.chatFactory?.chatDelegate = self;
            self.chatFactory?.chatModel.chatDelegate = self;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UITableViewDataSource delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.chatFactory == nil {
            return 0;
        }
        let tableViewCount = self.chatFactory!.getNumberOfRowsInCurrentModel();
        self.lastRowIndex = tableViewCount - 1;
        return tableViewCount;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : SPChatBaseViewCell = self.chatFactory!.getTableViewCell(tableView, indexPath: indexPath);
        cell.chatPageDelegate = self;
        return cell;
    }
    
    // MARK: UITableViewDelegate delegates
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.chatFactory!.estimatedHeightForRowAtIndexPath(indexPath);
    }

    // MARK: SPChatFactoryProtocol implementation
    func reloadChatComponents() {
        // reload chat output cells table view
        self.chatOutputTableView.reloadData();
        
        // get the current input view
        var chatInputViewControllerToAdd : SPChatBaseInputViewController = chatFactory!.getInputViewController();
        chatInputViewControllerToAdd.chatPageDelegate = self;
        
        // get the constant height of the new view (possibly obtained using a function?)
        let height : CGFloat = chatInputViewControllerToAdd.getHeight();
        
        // start animating the height change for the input view
        self.chatInputView.layoutIfNeeded();
        
        // set the new height for the chat input view
        self.chatInputViewHeight.constant = height;

        // start animating the height change for the input view
        UIView.animateWithDuration(0.2, animations: {
            self.chatInputView.layoutIfNeeded();
        }, completion: {
            [weak self] (completionValue: Bool) in
            if (self?.chatInputView != nil && self != nil) {
                // add the child input view controller
                self?.addChildViewControllerOnSubview(chatInputViewControllerToAdd, subview: self!.chatInputView!);
                
                // scroll to last element from the chat output table view
                if self?.chatMode == .FULL {
                    self?.scrollTableViewToLastRow();
                }
                if self?.chatMode == .READ_ONLY {
                    self?.scrollTableViewToDefaultNodeId();
                }
            }
            
        });
    }
    
    // MARK : Utils functions
    func scrollTableViewToLastRow() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {[weak self] () -> Void in
            if self?.lastRowIndex >= 0 {
                if let lastRowIndex = self?.lastRowIndex {
                    self?.chatOutputTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: lastRowIndex, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true);
                }
            }
        };
    }
    func scrollTableViewToDefaultNodeId() {
        let tableViewIndex = self.chatFactory!.getTableIndexForNodeId(defaultNodeId);
        if tableViewIndex != -1 {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {[weak self] () -> Void in
                self?.chatOutputTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableViewIndex, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true);
            };
        }
    }

    override func goBack(sender : UIBarButtonItem) {
        if self.chatMode == .FULL {
            var alert = UIAlertController(title: "", message: "Are you sure you want to quit the current game? All your progress will be lost.", preferredStyle: UIAlertControllerStyle.Alert);
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil));
            alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { action in
                // clean the submitted files
                self.chatFactory?.chatModel.userInputContainerModel.cleanLocalFiles();
                // if the current input is recording input, clean the temporary files
                if let recordingInput = self.chatFactory?.currentInputVC as? SPChatRecordingInputViewController {
                    if let recordingPaths = recordingInput.recordingModel?.recordingPaths {
                        SPUtils.deleteFilesFromDocumentsDirectory(recordingInput.recordingModel!.recordingPaths!);
                    }
                }
                
                super.goBack(sender);
            }));
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else if self.chatMode == .READ_ONLY {
            super.goBack(sender);
        }
        
    }
}
