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

    @property (nonatomic, strong) AppDelegate *globalVariables;
    @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
    @property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
    @property (weak, nonatomic)  NSDictionary<FBGraphUser> *user;
    @property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
    @property (strong, nonatomic) NSArray* selectedPartner;
    @property (weak, nonatomic) IBOutlet UIButton *invitePartnerButton;

@end


@implementation ViewController

@synthesize globalVariables = _globalVariables;
@synthesize user = _user;
@synthesize friendPickerController = _friendPickerController;
@synthesize selectedPartner = _selectedPartner;
@synthesize invitePartnerButton = _invitePartnerButton;





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.globalVariables = [[UIApplication sharedApplication] delegate];
 
    [self.loadingIndicator setHidesWhenStopped:YES];
    // TODO: check how to retrieve user information using new fb sdk
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            
            self.user = user;
            [self.loadingIndicator stopAnimating];
            self.userNameLabel.text = user.name;
            self.userProfileImage.profileID = user.id;
            
            //set the global userId
            self.globalVariables.fbUserId = user.id;
            

            
            //save the user in the DB if it's not already present
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"fbUserId" equalTo:user.id];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                PFObject *tempObject;
                if (!object) {
                    NSLog(@"Creating new user.");
                    PFObject *newUserObject = [PFObject objectWithClassName:@"User"];
                    [newUserObject setObject:user.id forKey:@"fbUserId"];
                    [newUserObject setObject:user.name forKey:@"username"];
                    [newUserObject saveEventually];
                    tempObject = newUserObject;
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the user.");
                    tempObject = object;
                }
                
                self.globalVariables.userId = tempObject.objectId;
                self.globalVariables.user = tempObject;
                
                PFQuery *query1 = [PFQuery queryWithClassName:@"Couple"];
                [query1 whereKey:@"user1Id" equalTo:user.id];
                PFQuery *query2 = [PFQuery queryWithClassName:@"Couple"];
                [query1 whereKey:@"user2Id" equalTo:user.id];
                
                NSMutableArray *queryArray = [[NSMutableArray alloc] init];
                [queryArray addObject:query1];
                [queryArray addObject:query2];
                
                PFQuery *compositeQuery = [PFQuery orQueryWithSubqueries:queryArray];
                
                [compositeQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (object) {
                        NSString *tempUser1Id = [object objectForKey:@"user1Id"];
                        NSString *tempUser2Id = [object objectForKey:@"user2Id"];
                        if([tempUser1Id isEqualToString:self.globalVariables.userId]){
                            self.globalVariables.partnerUserId = tempUser2Id;
                        }else{
                            self.globalVariables.partnerUserId = tempUser1Id;
                        }
                        //hide send invitation
                        self.invitePartnerButton.hidden = YES;
                        

                    }else{
                        NSLog(@"No couple found");
                    }
                    
                    
                    PFQuery *queryForPartnerFbId = [PFQuery queryWithClassName:@"User"];
                    PFObject *partner = [queryForPartnerFbId getObjectWithId:self.globalVariables.partnerUserId];
                    self.globalVariables.fbPartnerId = [partner objectForKey:@"fbUserId"];
            
                }];
            }];
    
            
        }];
    }    
    
}

- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    self.selectedPartner = friendPicker.selection;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)invitePartner {
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select Friends";
        self.friendPickerController.delegate = self;
    }
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    self.friendPickerController.allowsMultipleSelection = NO;
    [self presentModalViewController:self.friendPickerController animated:YES];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self dismissModalViewControllerAnimated:YES];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        NSLog(@"Friend selected: %@", user.name);
        
        //save the user in the DB if it's not already present
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        [query whereKey:@"fbUserId" equalTo:user.id];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            //create a new user for the partner
            PFObject *tempUser;
            if (!object) {
                NSLog(@"Creating new user.");
                PFObject *newUserObject = [PFObject objectWithClassName:@"User"];
                [newUserObject setObject:user.id forKey:@"fbUserId"];
                [newUserObject setObject:user.name forKey:@"username"];
                [newUserObject setObject:[NSNumber numberWithBool:YES] forKey:@"invitationSent"];
                [newUserObject save];
                tempUser = newUserObject;
            } else {
                // The find succeeded.
                NSLog(@"Successfully retrieved the user.");
                tempUser = object;
            }
            
            //set the global partnerUserId
            self.globalVariables.partnerUserId = tempUser.objectId;
            
            //Create the couple record
            PFObject *newCoupleObject = [PFObject objectWithClassName:@"Couple"];
            [newCoupleObject setObject:self.globalVariables.userId forKey:@"user1Id"];
            [newCoupleObject setObject:self.globalVariables.partnerUserId forKey:@"user2Id"];
            [newCoupleObject saveEventually];

            //update the current user: set sentInvitation true
            [self.globalVariables.user setObject:[NSNumber numberWithBool:YES] forKey:@"invitationSent"];
            [self.globalVariables.user saveInBackground];
        }];

        
        
    }
    [self dismissModalViewControllerAnimated:YES];
}


@end
