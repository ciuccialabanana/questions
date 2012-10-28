//
//  LoginViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, weak) Facebook *facebook;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.facebook = [Facebook sharedInstance];
    self.facebook.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLoginClick:(id)sender {
    [self checkFBSession];
}

#pragma mark - Facebook login

- (void)checkFBSession
{
    [self.facebook openSession];
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
