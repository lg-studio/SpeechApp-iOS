//
//  GooglePlusConnect.m
//  SpeechApp
//
//  Created by Ionut Paraschiv on 04/08/15.
//  Copyright (c) 2015 3angleTECH. All rights reserved.
//

#import "GooglePlusConnect.h"
#import <GoogleOpenSource/GoogleOpenSource.h>


@implementation GooglePlusConnect


-(id)init {
    if (self = [super init]) {
        self.signIn = [GPPSignIn sharedInstance];
        // signIn.shouldFetchGooglePlusUser = YES;
        self.signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
        
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *googleClientId = @"";
        if ([infoDict objectForKey:@"Google_ClientId"] != nil) {
            googleClientId = [infoDict objectForKey:@"Google_ClientId"];
        }
        else {
            NSLog(@"[ERROR] Google_ClientId is not defined in the plist file");
        }
        
        // You previously set kClientId in the "Initialize the Google+ client" step
        self.signIn.clientID = googleClientId;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        self.signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        // signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        // Optional: declare signIn.actions, see "app activities"
        self.signIn.delegate = self;
    }
    return self;
}

-(void) connectToGooglePlus {
    [self.delegate notifyStartLoading];
    [self.signIn authenticate];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error {
    
    if (error != nil || auth.accessToken == nil || auth.accessToken.length == 0) {
        [self.delegate didGetOauthCredentialsWithSuccess:FALSE andError:@"There was a problem logging in with Google. Please try again." withToken:@"" tokenSecret:@"" forProvider:@"Google"];
        return;
    }
    [self.delegate didGetOauthCredentialsWithSuccess:TRUE andError:@"" withToken:auth.accessToken tokenSecret:@"" forProvider:@"Google"];
}



@end
