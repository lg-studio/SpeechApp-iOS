//
//  AVPlayerDeallocItem.m
//  SpeechApp
//
//  Created by Ionut Paraschiv on 13/07/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

#import "AVPlayerDeallocItem.h"

@implementation AVPlayerDeallocItem
-(void)dealloc {
    if(self.itemDelegate != nil) {
        [self.itemDelegate itemDidDealloc:self];
    }
}
@end
