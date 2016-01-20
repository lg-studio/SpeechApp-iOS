//
//  SPChatRecordingInputViewControllerAVRecorderDelegateExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 02/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import AVFoundation


extension SPChatRecordingInputViewController : AVAudioRecorderDelegate {
    func startRecordingFromMicrophone(onCompletion : (Bool -> Void)) {
        if(self.audioRecorder != nil) {
            self.audioRecorder!.delegate = nil;
            self.audioRecorder = nil;
        }
        
        
        self.hasRecordPermission({
            hasPermission in
        
            if(!hasPermission) {
                onCompletion(false);
                return;
            }
            
            var error: NSError?;
            var audioSession : AVAudioSession = AVAudioSession.sharedInstance();
            
            audioSession.setCategory("AVAudioSessionCategoryPlayAndRecord", error: &error);
            if let e = error {
                SPUtils.displayErrorAlertController(e.description, viewController: self);
                onCompletion(false);
                return;
            }
            audioSession.setActive(true, error: &error);
            if let e = error {
                SPUtils.displayErrorAlertController(e.description, viewController: self);
                onCompletion(false);
                return;
            }
            audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error);
            
            var recordSettings = [
                AVEncoderAudioQualityKey:   AVAudioQuality.Min.rawValue,
                AVFormatIDKey           :   kAudioFormatMPEG4AAC,
                AVEncoderBitRateKey     :   16000,  // 128000
                AVNumberOfChannelsKey   :   1,
                AVSampleRateKey         :   8000.0  // 44100.0
            ];

            let uniqueStr : Double = NSDate().timeIntervalSince1970 * 1000.0;

            let path = SPUtils.getFullPathFromNSDocuments(String(format : "%.0f_%d.m4a", uniqueStr, self.numberOfRecordingsMade!));
            let soundFileURL = NSURL(fileURLWithPath: path);
            
            self.audioRecorder = AVAudioRecorder(URL: soundFileURL, settings: recordSettings as [NSObject : AnyObject], error: &error);
            if let e = error {
                SPUtils.displayErrorAlertController(e.description, viewController: self);
                onCompletion(false);
                return;
            } else {
                self.audioRecorder!.delegate = self;
                self.audioRecorder!.meteringEnabled = true;
                self.audioRecorder!.prepareToRecord(); // creates/overwrites the file at soundFileURL
            }
            
            self.audioRecorder!.record();
            self.invalidateTimer();
            self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                target:self,
                selector:"updateAudioMeter:",
                userInfo:nil,
                repeats:true);
            onCompletion(true);
        
        });
    };
    
    private func hasRecordPermission(onCompletion : (Bool -> Void)) {
        var error: NSError?;
        var audioSession : AVAudioSession = AVAudioSession.sharedInstance();
        audioSession.requestRecordPermission({(granted: Bool)-> Void in
            dispatch_async(dispatch_get_main_queue(), { [weak self] in
                if granted {
                    if self != nil {
                        onCompletion(true);
                    }
                }
                else {
                    if self != nil {
                        SPUtils.displayErrorAlertController("Please allow microphone access from the Settings Menu", viewController: self!);
                        onCompletion(false);
                        return;
                    }
                }
            });
        });
    }
    
    // MARK : AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(self.didFinishCurrentRecordingSuccesfully == true) {
            var urlInside = recorder.url;
            self.recordingModel?.addRecording(recorder.url.path!.lastPathComponent);
            
            if(self.chatPageDelegate != nil) {
                self.chatPageDelegate?.didAddAudioFileURL(recorder.url.path!.lastPathComponent);
            }
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
                println(">> failed with \(error)");
    }
    
}