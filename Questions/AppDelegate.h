//
//  AppDelegate.h
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *fbUserId;
@property (strong, nonatomic) NSString *fbPartnerId;
@property (strong, nonatomic) NSString *partnerUserId;
@property (strong, nonatomic) PFObject *user;

@end
