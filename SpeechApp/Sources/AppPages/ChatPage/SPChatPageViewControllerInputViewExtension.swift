//
//  SPChatPageViewControllerInputViewExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 02/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

// protocol that communicates from the input to the output view
protocol SPChatPageViewControllerInputViewProtocol : class {
    func didAddAudioFileURL(audioURL : String);
    func didAddRating(ratingModel : RatingInputModel);
    func didAddMultipleChoiceResponse(multipleChoiceModel : MultipleChoiceModel);
    
    func addUserInput(inputModel : BaseInputModel);
    func continueCurrentGame();
    func finishCurrentGame();
    func openFullScreenImage(imageURL : String);
}

extension SPChatPageViewController : SPChatPageViewControllerInputViewProtocol {
    func reloadChatTableView() {
        self.chatOutputTableView.reloadData();
        self.scrollTableViewToLastRow();
    }
    func didAddAudioFileURL(audioURL: String) {
        self.chatFactory?.generateAudioPromptModel(audioURL);
        self.reloadChatTableView();
    }
    func didAddRating(ratingModel : RatingInputModel) {
        self.chatFactory?.generateTextPromptModelAfterRating(ratingModel);
        self.reloadChatTableView();
    }
    func didAddMultipleChoiceResponse(multipleChoiceModel : MultipleChoiceModel) {
        self.chatFactory?.didAddMultipleChoiceResponse(multipleChoiceModel);
    }
    
    func continueCurrentGame() {
        self.reloadChatTableView();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { [weak self] in
            self?.chatFactory?.chatModel.continueCurrentGame();
        }
    }
    
    func addUserInput(inputModel : BaseInputModel) {
        self.chatFactory?.addUserInput(inputModel);
    }
    
    func finishCurrentGame() {
        if SPUtils.deviceIsConnectedOverWiFi() {
            self.uploadUserInputs();
            return;
        }
        // 3G
        var alert = UIAlertController(title: "", message: "Are you sure you want to send the results using your Cellular Data?", preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { action in
            self.uploadUserInputs();
        }));
        alert.addAction(UIAlertAction(title: "Save for WiFi", style: .Destructive, handler: { action in
            self.saveInputModelForLaterUpload();
        }));
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveInputModelForLaterUpload() {
        var chatInputsDatabase : SPChatInputsDatabase = SPChatInputsDatabase.getChatInputDatabase();
        chatInputsDatabase.addUserInputContainer(self.chatFactory!.chatModel.userInputContainerModel);
        self.goToPreviousPage();
    }
    func uploadUserInputs() {
        self.chatFactory?.chatModel.userInputContainerModel.sendToServer();
        self.goToPreviousPage();
    }
    
    private func goToPreviousPage() {
        self.shyNavBarManager.scrollView = nil;
        self.navigationController?.popViewControllerAnimated(true);
    }
    
}