//
//  ViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface ViewController () <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UIButton *invitePartnerButton;
@property (weak, nonatomic) IBOutlet UIButton *questionsButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = nil;
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.invitePartnerButton.enabled = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    self.nameLabel.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];    
    self.profilePicture.profileID = user.id;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.invitePartnerButton.enabled = NO;
    self.profilePicture.profileID = nil;
    self.nameLabel.text = nil;
}


# pragma mark - Facebook friend list delegates

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
