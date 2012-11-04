//
//  ViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "ViewController.h"

#import <Parse/Parse.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loggedInMessage;

@property (weak, nonatomic)  NSDictionary<FBGraphUser> *user;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // TODO: check how to retrieve user information using new fb sdk
//    if (FBSession.activeSession.isOpen) {
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection,
//           NSDictionary<FBGraphUser> *user,
//           NSError *error) {
//             if (!error) {
//                 self.user = user;     
//             }
//         }];
//    }


    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
