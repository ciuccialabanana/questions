//
//  ViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#import <Parse/Parse.h>

@interface ViewController ()

//@property (nonatomic, strong) AppDelegate *globalVariables;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *invitePartnerButton;

@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    //self.globalVariables = [[UIApplication sharedApplication] delegate];

    [self.loadingIndicator setHidesWhenStopped:YES];
    
    //hide send invitation
    self.invitePartnerButton.hidden = YES;
    

    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            self.userNameLabel.text = user.first_name;
            self.userProfileImage.profileID = user.id;
            [self.loadingIndicator stopAnimating];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (FBFriendPickerViewController *)friendPickerController
{
    if (!_friendPickerController) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select Friends";
        self.friendPickerController.delegate = self;
    }
    return _friendPickerController;
}


-(IBAction)invitePartner {
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    self.friendPickerController.allowsMultipleSelection = NO;
    [self presentViewController:self.friendPickerController animated:YES completion:^{}];
}

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
