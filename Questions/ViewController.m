//
//  ViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) Facebook *facebook;


@end


@implementation ViewController

@synthesize facebook = _facebook;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebook = [Facebook sharedInstance];
    self.facebook.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onLoginClick:(id)sender {
    [self checkFBSession];
}

#pragma mark - Facebook login

- (void)checkFBSession
{
    if ([self.facebook checkSession]) {
        [self performSegueWithIdentifier:@"signIn" sender:self];
    } else {
        [self.facebook openSession];
    }
}

- (void)facebookLoginSuccess
{
    [self performSegueWithIdentifier:@"signIn" sender:self];
}
- (void)facebookLoginFailed
{
    [self performSegueWithIdentifier:@"signIn" sender:self];
}



@end
