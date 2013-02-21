//
//  CategoryCollectionViewController.m
//  Questions
//
//  Created by Farid Hosseini on 2/7/13.
//  Copyright (c) 2013 FJ. All rights reserved.
//

#import "CategoryCollectionViewController.h"

@interface CategoryCollectionViewController ()

@end

@implementation CategoryCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
        [self.navigationController setNavigationBarHidden:NO animated:animated];

    self.view.backgroundColor = [UIColor clearColor];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
