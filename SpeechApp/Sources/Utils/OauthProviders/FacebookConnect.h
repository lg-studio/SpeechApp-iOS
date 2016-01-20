//
//  FacebookConnect.h
//  AllergyFoodFinder
//
//  Created by Ionut C. on 30/08/14.
//  Copyright (c) 2014 CodeBlasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AFFOAuthDelegate.h"

@interface FacebookConnect : NSObject

@property (weak) id <AFFOAuthDelegate> delegate;
-(void) connectToFB;

@end