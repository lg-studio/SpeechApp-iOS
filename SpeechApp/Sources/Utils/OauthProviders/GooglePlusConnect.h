//
//  GooglePlusConnect.h
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>
#import "AFFOAuthDelegate.h"

@interface GooglePlusConnect : NSObject <GPPSignInDelegate>

@property (weak) GPPSignIn *signIn;
@property (weak) id <AFFOAuthDelegate> delegate;

-(void) connectToGooglePlus;

@end
