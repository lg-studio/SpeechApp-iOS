//
//  AudioPromptModelPlayerExtension.swift
//  SpeechApp
//
//  Created by Ionut Paraschiv on 12/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

import UIKit

extension AudioPromptModel : BABAudioPlayerDelegate {
    // MARK:  BABAudioPlayerDelegate
    func audioPlayer(player: BABAudioPlayer!, didBeginPlayingAudioItem audioItem: BABAudioItem!) {
    }
    
    // BABAudioPlayer BUG: this function should be called when an audio finished, but it is called on all the player instances
    func audioPlayer(player: BABAudioPlayer!, didFinishPlayingAudioItem audioItem: BABAudioItem!) {
        self.audioPromptDelegate?.getAudioStopStartButton().enabled = true;
        self.audioPromptDelegate?.getAudioSlider().enabled = true;
        
        /* start BUG FIXING */
        if(self.elapsedPercent == 1.0) {
            self.elapsedPercent = 0.0;
            self.audioPromptDelegate?.getAudioSlider().value = self.elapsedPercent;
            self.audioPromptDelegate?.setInitialDurationOnLabel();
        }

        player.seekToPercent(self.elapsedPercent);
        player.pause();
        player.setState(BABAudioPlayerState.Paused);
        /* end BUG FIXING */
    }
    
    func audioPlayer(player: BABAudioPlayer!, didChangeState state: BABAudioPlayerState) {
        switch(state) {
        case BABAudioPlayerState.Playing:
            self.audioPromptDelegate?.getAudioSlider().enabled = true;
            self.audioPromptDelegate?.getAudioStopStartButton().enabled = true;
            self.audioPromptDelegate?.setButtonStopState();
            // the audioPromptModel has fulfilled when the playing state has been reached
            self.hasFulfilled();
            break;
        case BABAudioPlayerState.Waiting, BABAudioPlayerState.Paused:
            self.audioPromptDelegate?.getAudioSlider().enabled = state == BABAudioPlayerState.Paused;
            self.audioPromptDelegate?.getAudioStopStartButton().enabled = true;
            self.audioPromptDelegate?.setButtonPlayState();
            break;
        case BABAudioPlayerState.Buffering, BABAudioPlayerState.Scrubbing:
            self.audioPromptDelegate?.getAudioSlider().enabled = false;
            self.audioPromptDelegate?.getAudioStopStartButton().enabled = false;
            break;
        case BABAudioPlayerState.Stopped:
            break;
        default:
            break;
        }
    }
    
    // function called when the current item failed to load due to network problems
    func currentPlayingItemDidDealloc () {
        self.audioPlayer?.requeueItem(self.audioItem!);
    }
    
    func audioPlayer(player: BABAudioPlayer!, didChangeElapsedTime elapsedTime: NSTimeInterval, percentage: Float) {
        self.elapsedPercent = percentage;
        self.elapsedString = BABFormattedTimeStringFromTimeInterval(elapsedTime);
        self.audioPlayer(self.audioPlayer, didChangeState: self.audioPlayer!.state);
        
        // signal to the view cell the changes
        self.audioPromptDelegate?.getAudioSlider().value = percentage;
        self.audioPromptDelegate?.setAudioPromptViewState();
    }
    
    func audioPlayer(player: BABAudioPlayer!, didLoadMetadata metadata: [NSObject : AnyObject]!, forAudioItem audioItem: BABAudioItem!) {
        if let duration = metadata[MPMediaItemPropertyPlaybackDuration] as? NSTimeInterval {
            self.itemDuration = BABFormattedTimeStringFromTimeInterval(duration);
            self.audioPromptDelegate?.setInitialDurationOnLabel();
        }
    }
}