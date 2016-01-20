//
//  AudioPromptModelPlayerExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension AudioPromptModel {
    
    func initAudioPlayerItem() {
        lock (self) {
            if self.audioPlayer == nil {
                self.audioPlayer = BABAudioPlayer();
                self.audioPlayer?.delegate = self;
                self.queueItem();
            }
        }
    }
    private func queueItem() {
        // personal message or buffering enabled
        if self.isBufferingEnabled() || NSFileManager.defaultManager().fileExistsAtPath(SPUtils.getFullPathFromNSDocuments(self.audioURL!)) {
            var url : NSURL = self.getAudioURL();
            self.queueItemFromUrl(url);
        }
        // if buffering is disabled, download from the server
        // save locally and play with local URL
        else {
            var audioUrl = "";
            if let newAudioUrl = self.audioURL {
                audioUrl = newAudioUrl;
            }
            
            var request = NSMutableURLRequest(URL: NSURL(string: audioUrl)!);
            request.HTTPMethod = "GET";
            var session = NSURLSession.sharedSession();
            var task = session.dataTaskWithRequest(request, completionHandler: {[weak self] (data, response, error) -> Void in
                if error == nil && data != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        let queueResult = self?.queueItemUsingRemoteServerData(data);
                        if queueResult == false {
                            self?.requeueItemForDownload();
                        }
                    });
                }
                else {
                    self?.requeueItemForDownload();
                }
            });
            task.resume();
        }
    }
    
    private func requeueItemForDownload() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {[weak self] () -> Void in
            self?.queueItem();
        };
    }
    private func queueItemUsingRemoteServerData(data : NSData) -> Bool {
        let fullPath = SPUtils.getFullPathFromNSDocuments(String(format: "file%d.mp4", self.audioPromptIndex));
        let writeResult = data.writeToFile(fullPath, atomically: true);
        if writeResult == false {
            return false;
        }
        let url = NSURL(fileURLWithPath: fullPath);
        self.queueItemFromUrl(url!);
        return true;
    }
    private func queueItemFromUrl(url : NSURL) {
        self.audioItem = BABAudioItem(URL: url);
        self.audioPlayer?.queueItem(self.audioItem!);
    }
    
    // buffering enabled from plist
    private func isBufferingEnabled() -> Bool {
        var bufferingEnabled = false;
        if let bufferingProp = NSBundle.mainBundle().infoDictionary?["SpeechApp_AudioBufferingEnabled"] as? Bool {
            bufferingEnabled = bufferingProp;
        }
        return bufferingEnabled;
    }
}
