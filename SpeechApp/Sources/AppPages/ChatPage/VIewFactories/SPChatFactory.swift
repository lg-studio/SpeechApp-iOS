//
//  SPChatFactory.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

protocol SPChatFactoryProtocol : class {
    func reloadChatComponents();
    func reloadChatTableView();
}


class SPChatFactory: NSObject {
    let cellsIdentifiers : [String: String] =   [   "SPChatTextPromptViewCell"          :   "SPChatTextPromptViewCellIdentifier",
                                                    "SPChatRightTextPromptViewCell"     :   "SPChatRightTextPromptViewCellIdentifier",
        
                                                    "SPChatAudioPromptViewCell"         :   "SPChatAudioPromptViewCellIdentifier",
                                                    "SPChatRightAudioPromptViewCell"    :   "SPChatRightAudioPromptViewCellIdentifier",
    
                                                    "SPChatTextAreaPromptViewCell"      :   "SPChatTextAreaPromptViewCellIdentifier",
                                                    "SPChatRightTextAreaPromptViewCell" :   "SPChatRightTextAreaPromptViewCellIdentifier",
    
                                                    "SPChatImagePromptViewCell"         :   "SPChatImagePromptViewCellIdentifier",
                                                    "SPChatRightImagePromptViewCell"    :   "SPChatRightImagePromptViewCellIdentifier"];
    var chatMode : SPChatPageViewControllerMode;
    var chatModel : SPChatModel;
    var currentInputVC : SPChatBaseInputViewController?;
    weak var chatDelegate: SPChatFactoryProtocol?;
    var userDetailsModel : UserDetailsModel;
    
    init(view: UIView, chatMode : SPChatPageViewControllerMode, taskTemplateType : SPTaskTemplateType, taskTemplateId : String, taskId : String, optionId : Int?, subOptionId : Int?) {
        self.chatMode = chatMode;
        self.chatModel = SPChatModel(view: view, chatMode: chatMode, taskTemplateType : taskTemplateType, taskTemplateId : taskTemplateId, taskId: taskId, optionId : optionId, subOptionId: subOptionId);
        self.userDetailsModel = UserDetailsModel.loadUserDetailsModel();
        super.init();
    }
    
    func getBoxModelAtIndex(indexPath : NSIndexPath) -> BaseBoxModel {
        return chatModel.currentOutputModelsConfig[indexPath.row];
    }
    func estimatedHeightForRowAtIndexPath(indexPath : NSIndexPath) -> CGFloat {
        let boxModel = chatModel.currentOutputModelsConfig[indexPath.row];
        if(boxModel.estimatedHeight > 0) {
            return boxModel.estimatedHeight!;
        }
        
        switch(boxModel.boxModelType!) {
        case BoxModelTypes.TextPrompt.rawValue:
            return 100.0;
        case BoxModelTypes.AudioPrompt.rawValue:
            let convertedBoxModel = boxModel as! AudioPromptModel;
            if(convertedBoxModel.headerText?.length == 0) {
                return 70.0;
            }
            return 100.0;
        case BoxModelTypes.ImagePrompt.rawValue:
            let convertedBoxModel = boxModel as! ImagePromptModel;
            if(convertedBoxModel.textHeader?.length == 0) {
                return 120.0;
            }
            return 150.0;
        case BoxModelTypes.TextAreaPrompt.rawValue:
            return 220.0;
        default :
            return 100.0;
        }
    }
    
    func getTableViewCell(tableView : UITableView, indexPath : NSIndexPath) -> SPChatBaseViewCell {
        let boxModel = chatModel.currentOutputModelsConfig[indexPath.row];
        
        
        var cell : SPChatBaseViewCell;
        switch(boxModel.boxModelType!) {
        case BoxModelTypes.TextPrompt.rawValue:
            if(boxModel.personalMesage) {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatRightTextPromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatRightTextPromptViewCell;
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatTextPromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatTextPromptViewCell;
            }
            var convertedBoxModel = boxModel as! TextPromptModel;
            var convertedCell = cell as! SPChatBaseTextPromptViewCell;

            convertedCell.textModel = convertedBoxModel;
            break;
        
        case BoxModelTypes.AudioPrompt.rawValue:
            if(boxModel.personalMesage) {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatRightAudioPromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatRightAudioPromptViewCell;
            }
            else {
                // TODO : change to right audio file
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatAudioPromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatAudioPromptViewCell;
            }
            var convertedBoxModel = boxModel as! AudioPromptModel;
            var convertedCell = cell as! SPChatBaseAudioPromptViewCell;
            // if the cell was reused, dealloc the old model's delegate
            convertedCell.audioPromptModel?.audioPromptDelegate = nil;
            // set the new delegate to the box model
            convertedBoxModel.audioPromptDelegate = convertedCell;
            
            convertedCell.audioPromptModel = convertedBoxModel;
            break;
        case BoxModelTypes.TextAreaPrompt.rawValue:
            if(boxModel.personalMesage) {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatRightTextAreaPromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatRightTextAreaPromptViewCell;
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatTextAreaPromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatTextAreaPromptViewCell;
            }
            var convertedBoxModel = boxModel as! TextAreaPromptModel;
            var convertedCell = cell as! SPChatBaseTextAreaPromptViewCell;
            
            convertedCell.textAreaPromptModel = convertedBoxModel;
            break;
        case BoxModelTypes.ImagePrompt.rawValue:
            if (boxModel.personalMesage) {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatRightImagePromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatRightImagePromptViewCell;
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("SPChatImagePromptViewCellIdentifier", forIndexPath:indexPath) as! SPChatImagePromptViewCell;
            }
            var convertedBoxModel = boxModel as! ImagePromptModel;
            var convertedCell = cell as! SPChatBaseImagePromptViewCell;
            
            convertedCell.imagePromptModel = convertedBoxModel;
            break;
            
        default:
            cell = SPChatBaseViewCell();
            break;
        }
        
        // set the common attributes
        if boxModel.outputFulfilledDelegate == nil {
            boxModel.outputFulfilledDelegate = self;
        }
        cell.boxModel = boxModel;
        cell.reloadCell();
        return cell;
    }
    
    func registerCellIdentifiersOnTableView (tableView : UITableView) {
        for (nibName, cellIdentifier) in self.cellsIdentifiers {
            tableView.registerNib(UINib(nibName: nibName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifier);
        }
    }
    func getNumberOfRowsInCurrentModel() -> Int {
        return self.chatModel.currentOutputModelsConfig.count;
    }
    func getTableIndexForNodeId(defaultNodeId : Int) -> Int {
        for (var index = 0; index < self.chatModel.currentOutputModelsConfig.count; index++) {
            let boxModel = self.chatModel.currentOutputModelsConfig[index];
            if boxModel.nodeId != nil && boxModel.nodeId! == defaultNodeId {
                return index;
            }
        }
        return -1;
    }
    
}