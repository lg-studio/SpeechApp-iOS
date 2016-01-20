//
//  SPChatInputsDatabase.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 09/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

class SPChatInputsDatabase: NSObject {
    static let Key = "SPChatInputsDatabaseKey";
    
    // the singleton database object instance
    private static let chatInputDatabaseInstance = SPChatInputsDatabase.chatInputDatabase;
    private static var chatInputDatabase : SPChatInputsDatabase {
        get {
            return SPChatInputsDatabase();
        }
    };
    
    // function that returns the singleton database object
    static func getChatInputDatabase() -> SPChatInputsDatabase {
        return SPChatInputsDatabase.chatInputDatabaseInstance;
    }
    
    // the inputs of the user
    var userInputs : [SPChatUserInputContainerModel]?;
    
    override init() {
        super.init();
        self.userInputs = self.loadEntity();
    }
    
    func addUserInputContainer(userInputContainer : SPChatUserInputContainerModel) {
        lock(self) {
            self.userInputs?.append(userInputContainer);
            self.persistEntity();
        }

    }
    private func hasInputContainers() -> Bool {
        return self.userInputs!.count > 0;
    }
    private func getFirstInputContainer() -> SPChatUserInputContainerModel {
        return userInputs![0];
    }
    private func removeFirstInputContainer() {
        self.userInputs!.removeAtIndex(0);
        self.persistEntity();
        
    }
    
    func sendAllEntriesToServer() {
        lock(self) {
            var loggedInUserId = "";
            let dbUserId = UserDetailsModel.loadUserDetailsModel().userId;
            if dbUserId != nil {
                loggedInUserId = dbUserId!;
            }
            
            while(self.hasInputContainers()) {
                var inputContainerModel : SPChatUserInputContainerModel = self.getFirstInputContainer();
                // only send to the server the answers of the logged in user
                if inputContainerModel.userId == loggedInUserId {
                    inputContainerModel.sendToServer();
                }
                self.removeFirstInputContainer();
            }
        }
    }
    
    // Database functions
    private func loadEntity() -> [SPChatUserInputContainerModel] {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(SPChatInputsDatabase.Key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [SPChatUserInputContainerModel];
        }
        return [];
    }
    private func persistEntity() {
        NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(self.userInputs!), forKey: SPChatInputsDatabase.Key);
    }
}
