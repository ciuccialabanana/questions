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

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic)  NSDictionary<FBGraphUser> *user;

@end


@implementation ViewController

@synthesize user = _user;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loadingIndicator setHidesWhenStopped:YES];
    // TODO: check how to retrieve user information using new fb sdk
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            self.user = user;
            [self.loadingIndicator stopAnimating];
            self.userNameLabel.text = user.name;
        }];
    }    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
