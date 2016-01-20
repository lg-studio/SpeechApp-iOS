//
//  SPChatBaseTextPromptViewCellTableViewCell.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 24/06/15.
//  Copyright (c) 2015 Ionut Paraschiv. All rights reserved.
//

import UIKit

protocol SPChatBaseAudioPromptViewCellPlayerProtocol : class {
    // UI elements
    func getAudioStopStartButton() -> UIButton;
    func getAudioSlider() -> UISlider;
    func setButtonStopState();
    func setButtonPlayState();
    func setAudioPromptViewState();
    func setInitialDurationOnLabel();
}

class SPChatBaseAudioPromptViewCell: SPChatBaseViewCell, SPChatBaseAudioPromptViewCellPlayerProtocol {
    var audioPromptModel : AudioPromptModel?;
    
    @IBOutlet weak var headerTextLabel: UIBorderedLabel!;
    @IBOutlet weak var audioViewContainer: UIView!;
    @IBOutlet weak var audioSlider: UISlider!;
    @IBOutlet weak var audioStopStartButton: UIButton!;
    @IBOutlet weak var audioProgressLabel: UILabel!;
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
        self.headerTextLabel.setRoundCorners();
        self.audioViewContainer.setRoundCorners();
    }
    
    override func reloadCell() {
        headerTextLabel.text = self.audioPromptModel?.headerText;
        if self.audioPromptModel?.headerText?.length == 0 {
            self.headerTextLabel.hidden = true;
        }
        else {
            self.headerTextLabel.hidden = false;
            headerTextLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 92;
        }
        self.initAudioPlayer();
        super.reloadCell();
    }
    
    func initAudioPlayer() {
        self.audioPromptModel?.initAudioPlayerItem();
        
        // configure the player for the current view
        BABConfigureSliderForAudioPlayer(self.audioSlider, self.audioPromptModel?.audioPlayer);
        self.setAudioPromptViewState();
        self.audioSlider.value = self.audioPromptModel!.elapsedPercent;
        if let state = self.audioPromptModel?.audioPlayer!.state {
            self.audioPromptModel?.audioPlayer(self.audioPromptModel!.audioPlayer, didChangeState: state);
        }
    }
    
    @IBAction func audioPlayerButton(sender: AnyObject) {
        self.audioPromptModel?.audioPlayer?.togglePlaying();
    }
    
    func setButtonPlayState() {
        self.audioStopStartButton.setImage(UIImage(named: "PlayButtonIcon"), forState: UIControlState.Normal);
    }
    func setButtonStopState() {
        self.audioStopStartButton.setImage(UIImage(named: "PauseButtonIcon"), forState: UIControlState.Normal);
    }
    
    // MARK SPChatBaseAudioPromptViewCellPlayerProtocol implementation
    func getAudioStopStartButton() -> UIButton {
        return self.audioStopStartButton;
    }
    func getAudioSlider() -> UISlider {
        return self.audioSlider;
    }
    func setInitialDurationOnLabel() {
        self.audioProgressLabel.text = String(format: "0:00/%@", arguments: [self.audioPromptModel!.itemDuration!]);
    }
    
    func setAudioPromptViewState() {
        let durationString = BABFormattedTimeStringFromTimeInterval(self.audioPromptModel!.audioPlayer!.duration);
        self.audioProgressLabel.text = String(format: "%@/%@", arguments: [self.audioPromptModel!.elapsedString!, durationString]);
    }
}
