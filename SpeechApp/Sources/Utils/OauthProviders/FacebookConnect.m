//
//  FacebookConnect.m
//  AllergyFoodFinder
//
//  Created by Ionut C. on 30/08/14.
//  Copyright (c) 2014 CodeBlasters. All rights reserved.
//

#import "FacebookConnect.h"

@implementation FacebookConnect

-(void) connectToFB {
    [self.delegate notifyStartLoading];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            [self.delegate didGetOauthCredentialsWithSuccess:FALSE andError:[[NSString alloc] initWithFormat:@"Error logging in with Facebook. Please try again. %@", error.localizedDescription] withToken:@"" tokenSecret:@"" forProvider:@"Facebook"];
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [self.delegate didGetOauthCredentialsWithSuccess:TRUE andError:@"" withToken:result.token.tokenString tokenSecret:@"" forProvider:@"Facebook"];
            }
        }
    }];
}
@end