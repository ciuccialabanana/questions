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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *loggedInMessage;
@property (weak, nonatomic) IBOutlet UILabel *randomQuestionLabel;

@property (weak, nonatomic)  NSDictionary<FBGraphUser> *user;

@property (strong, nonatomic)  FBFriendPickerViewController *friendPickerController;

@end


@implementation ViewController

@synthesize friendPickerController = _friendPickerController;
- (void)viewDidLoad
{
    [super viewDidLoad];

    __block NSString *welcomeMessage;
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.user = user;     
             }
         }];
    }
    
    welcomeMessage = [@"Welcome " stringByAppendingString: @"self.user.name"];
    
    self.loggedInMessage.text =  welcomeMessage;
    

    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query whereKey:@"category" equalTo:@"soccer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d questions.", objects.count);
            PFObject *question = objects[0];
            NSString *questionText = [question objectForKey:@"text"];
            self.randomQuestionLabel.text = questionText;
            
//            NSString *questionAnswersString = [question objectForKey:@"answers"];
//            NSArray *answers = [questionAnswersString componentsSeparatedByString: @","];
//            for(int i = 0; i < [answers count]; i++){
//                UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(10, 10, 100, 100)];
//                label.text = answers[i];
//                [self.view addSubView:label];
//            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
//    PFObject *question = [query getObjectWithId:@"xWMyZ4YEGZ"];
//    
//    int score = [[gameScore objectForKey:@"score"] intValue];
//    NSString *playerName = [gameScore objectForKey:@"playerName"];
//    BOOL cheatMode = [[gameScore objectForKey:@"cheatMode"] boolValue];
//    
//    NSString *objectId = gameScore.objectId;
//    NSDate *updatedAt = gameScore.updatedAt;
//    NSDate *createdAt = gameScore.createdAt;
    
    self.randomQuestionLabel.text = @"Welcome ";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onSendQuestion:(id)sender {
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    self.friendPickerController.title = @"Select Friends";
    self.friendPickerController.delegate = self;
    

    [self presentViewController:self.friendPickerController animated:YES completion:^() {
        NSLog(@"friends list loaded");
    }];

}

- (void) handlePickerDone
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    NSLog(@"Friend selection cancelled.");
    [self handlePickerDone];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        NSLog(@"Friend selected: %@", user.name);
    }
    [self handlePickerDone];
}


@end
