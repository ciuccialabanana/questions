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
#import "Storage.h"

@interface ViewController () <FBLoginViewDelegate, FBFriendPickerDelegate>


@property (nonatomic, weak) Storage *storage;

@property (nonatomic, weak) IBOutlet FBProfilePictureView *profilePicture;
@property (nonatomic, weak) IBOutlet UIButton *invitePartnerButton;
@property (nonatomic, weak) IBOutlet UIButton *questionsButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;


@property (nonatomic, strong) FBFriendPickerViewController *friendPickerController;

@end


@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameLabel.text = nil;
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.frame = CGRectOffset(loginview.frame, 20, 280);
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];
    
    
    self.storage = [Storage sharedInstance];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)onInvitePartnerClick:(id)sender {
    self.friendPickerController = [[FBFriendPickerViewController alloc] init];
    self.friendPickerController .title = @"Pick your Partner";
    self.friendPickerController .delegate = self;
    self.friendPickerController .allowsMultipleSelection = NO;
    
    [self.friendPickerController  loadData];
    
    [self presentViewController:self.friendPickerController  animated:YES completion:^{}];
}



#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.invitePartnerButton.enabled = YES;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    self.nameLabel.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];    
    self.profilePicture.profileID = user.id;
    [self.storage fetchUserInformationWithFacebookId:user.id forUser:self.storage.user];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.invitePartnerButton.enabled = NO;
    self.profilePicture.profileID = nil;
    self.nameLabel.text = nil;
    [self.storage clearCurrentUser];
}

# pragma mark - Facebook friend list delegates

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    NSArray *selection = [self.friendPickerController selection];
    
    if ([selection count] > 1) {
        NSLog(@"Error on friend's selection");
    }
    
    if ([selection count] == 1) {
        id<FBGraphUser> partner = [selection lastObject];
        [self.storage createCoupleToConfirmWithPartnerFacebookId:partner.id];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}


@end
