//
//  AFFOAuthDelegate.h
//  AllergyFoodFinder
//
//  Created by Ionut C. on 30/08/14.
//  Copyright (c) 2014 CodeBlasters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFFOAuthDelegate <NSObject>

- (UIView *)viewForActionSheet;
- (void)didGetOauthCredentialsWithSuccess:(BOOL)success andError:(NSString*)err withToken:(NSString*)oAuthToken tokenSecret:(NSString*)oAuthTokenSecret forProvider:(NSString*)provider;
- (void)notifyStartLoading;

@end
