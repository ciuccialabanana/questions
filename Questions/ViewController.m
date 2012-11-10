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

    @property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
    @property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

    @property (strong, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;


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
            self.userProfileImage.profileID = user.id;
            
            //set the global userId
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.fbUserId = user.id;
            
            //save the user in the DB if it's not already present
            PFQuery *query = [PFQuery queryWithClassName:@"User"];
            [query whereKey:@"fbUserId" equalTo:user.id];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                PFObject *tempObject;
                if (!object) {
                    NSLog(@"Creating new user.");
                    PFObject *newUserObject = [PFObject objectWithClassName:@"User"];
                    //                [newUserObject setObjectId:user.id];
                    [newUserObject setObject:user.id forKey:@"fbUserId"];
                    [newUserObject setObject:user.name forKey:@"username"];
                    [newUserObject saveEventually];
                    tempObject = newUserObject;
                } else {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved the user.");
                    tempObject = object;
                }
                
                appDelegate.userId = tempObject.objectId;
                
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
                        if([tempUser1Id isEqualToString:appDelegate.userId]){
                            appDelegate.partnerUserId = tempUser2Id;
                        }else{
                            appDelegate.partnerUserId = tempUser1Id;
                        }

                    }else{
                        NSLog(@"No couple found");
                    }
                
                }];
            }];
    
            
        }];
    }    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
