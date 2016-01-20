//
//  TwitterConnect.m
//  AllergyFoodFinder
//
//  Created by Ionut C. on 30/08/14.
//  Copyright (c) 2014 CodeBlasters. All rights reserved.
//

#import "TwitterConnect.h"

#define TW_API_ROOT                  @"https://api.twitter.com"
#define TW_X_AUTH_MODE_KEY           @"x_auth_mode"
#define TW_X_AUTH_MODE_REVERSE_AUTH  @"reverse_auth"
#define TW_X_AUTH_MODE_CLIENT_AUTH   @"client_auth"
#define TW_X_AUTH_REVERSE_PARMS      @"x_reverse_auth_parameters"
#define TW_X_AUTH_REVERSE_TARGET     @"x_reverse_auth_target"
#define TW_OAUTH_URL_REQUEST_TOKEN   TW_API_ROOT "/oauth/request_token"
#define TW_OAUTH_URL_AUTH_TOKEN      TW_API_ROOT "/oauth/access_token"

typedef void(^TWAPIHandler)(NSData *data, NSError *error);

@implementation TwitterConnect

@synthesize accountStore;
@synthesize sheet;

-(void) getAccountsUsingView:(UIView*)view {
    @try {
        ACAccountStore *_accountStore = [[ACAccountStore alloc] init];
        ACAccountType *twitterType = [_accountStore accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierTwitter];
        [_accountStore requestAccessToAccountsWithType:twitterType options:nil
        completion:^(BOOL granted, NSError *error) {
            if (granted == NO) {
                dispatch_async(dispatch_get_main_queue(),^ {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Integration Error" message:@"No permissions to get Twitter accounts. Check settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                });
            }
            else {
                self.accounts = [_accountStore accountsWithAccountType:twitterType];
                if(self.accounts.count == 0) {
                    dispatch_async(dispatch_get_main_queue(),^ {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Integration Error" message:@"There are no Twitter accounts found in settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),^ {
                        // we have accounts
                        sheet = [[UIActionSheet alloc] initWithTitle:@"Choose an Account" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                        for (ACAccount *acct in _accounts) {
                            [sheet addButtonWithTitle:acct.username];
                        }
                        sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
                        [sheet showInView:[self.delegate viewForActionSheet]];
                    });
                }
            }
        }];
    } @catch (id exception) {
        dispatch_async(dispatch_get_main_queue(),^ {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Twitter Integration Error"
                                      message:[exception reason]
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        });
    }
}

-(void) connectToTW:(NSInteger)accIndex {
    [self.delegate notifyStartLoading];
    [self _step1WithCompletion:^(NSData *data, NSError *error) {
        if (!data) {
            [self.delegate didGetOauthCredentialsWithSuccess:FALSE andError:@"There was a problem logging in with Twitter. Please try again." withToken:nil tokenSecret:nil forProvider:nil];
        }
        else {
            NSString *signedReverseAuthSignature = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self _step2WithAccount:[self.accounts objectAtIndex:accIndex] signature:signedReverseAuthSignature andHandler:^(NSData *responseData, NSError *error) {
                NSString *responseStr =
                [[NSString alloc] initWithData:responseData
                                      encoding:NSUTF8StringEncoding];
                
                // see below for an example response
                NSArray *fields = [responseStr componentsSeparatedByString:@"&"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                for (int i=0; i<fields.count; i++) {
                    NSArray *fieldsInside = [fields[i] componentsSeparatedByString:@"="];
                    if (fieldsInside.count < 2) {
                        continue;
                    }
                    NSString * key = [fieldsInside objectAtIndex:0];
                    NSString * value = [fieldsInside objectAtIndex:1];
                    [dict setObject:value forKey:key];
                }
                
                [self.delegate didGetOauthCredentialsWithSuccess:TRUE andError:nil withToken:[dict objectForKey:@"oauth_token"] tokenSecret:[dict objectForKey:@"oauth_token_secret"] forProvider:@"Twitter"];
            }];
            
        }
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self connectToTW:buttonIndex];
    }
}

/**
 *  The first stage of Reverse Auth.
 *
 *  In this step, we sign and send a request to Twitter to obtain an
 *  Authorization: header which we will use in Step 2.
 *
 *  @param completion   The block to call when finished.  Can be called on any
 *                      thread.
 */
- (void)_step1WithCompletion:(TWAPIHandler)completion
{
    NSURL *url = [NSURL URLWithString:TW_OAUTH_URL_REQUEST_TOKEN];
    NSDictionary *dict = @{TW_X_AUTH_MODE_KEY: TW_X_AUTH_MODE_REVERSE_AUTH};
    TWSignedRequest *step1Request = [[TWSignedRequest alloc] initWithURL:url parameters:dict requestMethod:TWSignedRequestMethodPOST];
    [step1Request performRequestWithHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(data, error);
        });
    }];
}
- (void)_step2WithAccount:(ACAccount *)account signature:(NSString *)signedReverseAuthSignature andHandler:(TWAPIHandler)completion
{
    NSParameterAssert(account);
    NSParameterAssert(signedReverseAuthSignature);
    
    NSDictionary *step2Params = @{TW_X_AUTH_REVERSE_TARGET: [TWSignedRequest consumerKey], TW_X_AUTH_REVERSE_PARMS: signedReverseAuthSignature};
    NSURL *authTokenURL = [NSURL URLWithString:TW_OAUTH_URL_AUTH_TOKEN];
    SLRequest *step2Request = [self requestWithUrl:authTokenURL parameters:step2Params requestMethod:SLRequestMethodPOST];
    [step2Request setAccount:account];
    [step2Request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(responseData, error);
        });
    }];
}
- (SLRequest *)requestWithUrl:(NSURL *)url parameters:(NSDictionary *)dict requestMethod:(SLRequestMethod )requestMethod
{
    NSParameterAssert(url);
    NSParameterAssert(dict);
    
    return [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:requestMethod URL:url parameters:dict];
}

@end
