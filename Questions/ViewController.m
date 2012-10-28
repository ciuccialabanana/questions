//
//  ViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()

@property (strong, nonatomic)  FBFriendPickerViewController *friendPickerController;

@end


@implementation ViewController

@synthesize friendPickerController = _friendPickerController;
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    

    [self presentViewController:self.friendPickerController animated:YES completion:^() {
        NSLog(@"friends list loaded");
    }];

}


@end
