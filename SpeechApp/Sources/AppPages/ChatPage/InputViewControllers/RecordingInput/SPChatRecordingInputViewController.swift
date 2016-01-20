//
//  SPChatRecordingInputViewController.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 01/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit
import AVFoundation

enum SPChatRecordingInputViewControllerStatus : Int {
    case StatusPlaying = 1
    case StatusStopped = 2
};

class SPChatRecordingInputViewController: SPChatBaseInputViewController {
    @IBOutlet weak var buttonStopStart: UIButton!
    @IBOutlet weak var buttonFinishedRecordings: UIButton!
    @IBOutlet weak var buttonRestartRecording: UIButton!
    @IBOutlet weak var sliderRecordingStatus: UISlider!
    @IBOutlet weak var labelRecordingStatus: UILabel!
    @IBOutlet weak var labelMinTime: UILabel!;
    @IBOutlet weak var labelMaxTime: UILabel!;
    @IBOutlet weak var constraintMinTimeLeading: NSLayoutConstraint!;
    
    
    var recordingModel : RecordingInputModel?;
    
    var recordingStatus : Int?;
    var recordingStatusImages : [Int:String] = [SPChatRecordingInputViewControllerStatus.StatusPlaying.rawValue : "SubmitCheckIcon",
                                                SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue : "MicrophoneButton"];
    var numberOfRecordingsMade : Int?;
    
    // information about the current recording
    var audioRecorder:AVAudioRecorder?;
    var elapsedSeconds : Float?;
    var retriesNumber : Int?;
    var meterTimer : NSTimer?;
    var didFinishCurrentRecordingSuccesfully : Bool?;
    
    init(recordingModel : RecordingInputModel) {
        super.init(nibName: "SPChatRecordingInputViewController", bundle: nil);
        
        self.recordingModel = recordingModel;
        self.recordingStatus = SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue;
        self.elapsedSeconds = 0;
        self.numberOfRecordingsMade = 0;
        self.retriesNumber = 0;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.updatePageUI();
        self.labelMinTime.text = self.formatDurationInSecondsForPrint(Float(self.recordingModel!.minLength!));
        self.labelMaxTime.text = self.formatDurationInSecondsForPrint(Float(self.recordingModel!.maxLength!));
        self.setLabelMinTimeX();
    }
    override func viewDidDisappear(animated: Bool) {
        self.invalidateTimer();
        super.viewDidDisappear(animated);
    }
    deinit {
        self.invalidateTimer();
        if(self.audioRecorder != nil) {
            self.audioRecorder!.delegate = nil;
            self.audioRecorder = nil;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func getHeight() -> CGFloat {
        return self.view.frame.height;
    }
    
    private func setLabelMinTimeX() {
        if self.recordingModel!.maxLength! == 0 {
            return;
        }
        let ratio : Float = Float(self.recordingModel!.minLength!) / Float(self.recordingModel!.maxLength!);
        self.constraintMinTimeLeading!.constant = floor(CGFloat(ratio) * (UIScreen.mainScreen().bounds.width - 80.0));
    }
    
    func updatePageUI() {
        self.buttonFinishedRecordings.hidden = true;
        self.buttonRestartRecording.hidden = true;
        self.buttonStopStart.enabled = true;
        
        switch self.recordingStatus! {
        case SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue:
            if(self.numberOfRecordingsMade >= recordingModel!.maxRecordings) {
                self.buttonStopStart.enabled = false;
                self.buttonFinishedRecordings.hidden = false;
            }
            else if(self.numberOfRecordingsMade > 0) {
                self.buttonFinishedRecordings.hidden = false;
            }
            break;
        case SPChatRecordingInputViewControllerStatus.StatusPlaying.rawValue:
            if(self.retriesNumber < recordingModel?.maxRetriesPerRecording) {
                self.buttonRestartRecording.hidden = false;
            }
            if(Int(self.elapsedSeconds!) >= recordingModel?.minLength) {
                self.buttonStopStart.enabled = true;
            }
            else {
                self.buttonStopStart.enabled = false;
            }
            break;
        default:
            break;
        }
        
        self.labelRecordingStatus.text = self.formatDurationInSecondsForPrint(self.elapsedSeconds!);
        self.sliderRecordingStatus.value = Float(self.elapsedSeconds!) / Float(recordingModel!.maxLength!);
        if(Int(self.elapsedSeconds!) < recordingModel!.minLength) {
            self.sliderRecordingStatus.minimumTrackTintColor = UIColor.redColor();
        }
        else if(Int(self.elapsedSeconds!) >= recordingModel!.maxLength! - 10) {
            self.sliderRecordingStatus.minimumTrackTintColor = UIColor.redColor();
        }
        else {
            self.sliderRecordingStatus.minimumTrackTintColor = UIColor.greenColor();
        }
        self.setStopStartButtonImage();
    }
    
    @IBAction func buttonStopStartAction(sender: AnyObject) {
        if self.fulfilledStatus == SPChatBaseInputStatus.WAIT {
            SPUtils.displayAlertController("Info", message: "You must listen to all the audios to submit your answer", viewController: self);
            return;
        }
        switch self.recordingStatus! {
        case SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue:
            // start recording
            self.recordingStatus = SPChatRecordingInputViewControllerStatus.StatusPlaying.rawValue;
            self.startRecording();
            break;
        case SPChatRecordingInputViewControllerStatus.StatusPlaying.rawValue:
            // finished recording
            self.recordingStatus = SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue;
            self.finishRecording();
            break;
        default:
            break;
        }
        self.updatePageUI();
    }
    @IBAction func buttonFinishedRecordingsAction(sender: AnyObject) {
        self.closeCurrentRecordingInput();
    }
    @IBAction func buttonRestartRecordingAction(sender: AnyObject) {
        self.retriesNumber = self.retriesNumber! + 1;
        self.recordingStatus = SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue;
        self.stopRecording();
        self.updatePageUI();
    }
    
    func setStopStartButtonImage() {
        self.buttonStopStart.setImage(UIImage(named: recordingStatusImages[self.recordingStatus!]!), forState: UIControlState.Normal);
    }
    
    // function called on the start recording button
    func startRecording() {
        self.elapsedSeconds = 0;
        self.didFinishCurrentRecordingSuccesfully = false;
        self.startRecordingFromMicrophone({
            result in
            
            if(result == false) {
                self.recordingStatus = SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue;
                return;
            }
        });
    }
    // function called when the current recording finished succesfully
    func finishRecording() {
        self.retriesNumber = 0;
        self.elapsedSeconds = 0;
        self.numberOfRecordingsMade = self.numberOfRecordingsMade! + 1;
        self.didFinishCurrentRecordingSuccesfully = true;
        self.invalidateTimer();
        if (self.audioRecorder?.recording != nil) {
            self.audioRecorder?.stop();
        }
        
        if(self.numberOfRecordingsMade == self.recordingModel?.maxRecordings) {
            
            // continue the game after a timeout to allow AVAudioRecorder to add the recording inside the page
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {[weak self] () -> Void in
                self?.closeCurrentRecordingInput();
            };
        }
    }
    
    // function called to restart the current recording
    func stopRecording() {
        self.elapsedSeconds = 0;
        self.invalidateTimer();
        if (self.audioRecorder?.recording != nil) {
            self.audioRecorder?.stop();
        }
        
    }
    
    // function called once every one second
    func updateAudioMeter(timer:NSTimer) {
        if (self.audioRecorder?.recording != nil) {
            self.elapsedSeconds = Float(self.audioRecorder!.currentTime);
            // stop if the maximum time limit is achieved
            if(Int(self.elapsedSeconds!) >= recordingModel!.maxLength) {
                self.recordingStatus = SPChatRecordingInputViewControllerStatus.StatusStopped.rawValue;
                self.finishRecording();
            }
            self.updatePageUI();
        }
    }
    func invalidateTimer() {
        if(self.meterTimer != nil) {
            self.meterTimer?.invalidate();
            self.meterTimer = nil;
        }
    }
    
    // function that is called when the recordings have finished
    func closeCurrentRecordingInput() {
        self.buttonFinishedRecordings.enabled = false;
        self.buttonStopStart.enabled = false;
        // continue the game
        self.chatPageDelegate?.continueCurrentGame();
        // save the current RecordingInputModel to the game state array
        self.chatPageDelegate?.addUserInput(self.recordingModel!);
    }
    
    private func formatDurationInSecondsForPrint(durationSec : Float) -> String {
        let min:Int = Int(durationSec / 60)
        let sec:Int = Int(durationSec % 60)
        return String(format: "%d:%02d", min, sec);
    }
}