//
//  Facebook.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "Facebook.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation Facebook

@synthesize delegate = _delegate;


+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _instance = nil;
    dispatch_once(&pred, ^{
        _instance = [[self alloc] init]; // or some other init method
    });
    return _instance;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            FBCacheDescriptor *cacheDescriptor = [FBFriendPickerViewController cacheDescriptor];
            [cacheDescriptor prefetchAndCacheForSession:session];
            [self.delegate facebookLoginSuccess];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [self.delegate facebookLoginFailed];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)closeSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)checkSession
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        return YES;
    } else {
        return NO;
    }
}

@end
