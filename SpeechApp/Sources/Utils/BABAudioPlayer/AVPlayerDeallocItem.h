//
//  AVPlayerDeallocItem.h
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BABAudioPlayerDelegate.h"

@interface AVPlayerDeallocItem : AVPlayerItem
@property (weak, readwrite) id <BABAudioPlayerItemDelegate> itemDelegate;
@end
