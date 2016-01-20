//
//  TwitterConnect.h
//  AllergyFoodFinder
//
//  Created by Ionut C. on 30/08/14.
//  Copyright (c) 2014 CodeBlasters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TWSignedRequest.h"
#import "AFFOAuthDelegate.h"

@interface TwitterConnect : NSObject <UIActionSheetDelegate> {
}
@property (weak) id <AFFOAuthDelegate> delegate;

@property (nonatomic, retain) ACAccountStore* accountStore;
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) UIActionSheet *sheet;


-(void) connectToTW:(NSInteger)accIndex;
-(void) getAccountsUsingView:(UIView*)view;

@end