//
//  GFPFriendPickerViewController.m
//  Grio Friend Picker
//
//  Created by Giuseppe Macri on 10/15/12.
//  Copyright (c) 2012 Grio. All rights reserved.
//

#import "GFPFriendPickerViewController.h"
#import "GFPFacebook.h"

@interface GFPFriendPickerViewController ()

@property (retain, nonatomic) UISearchBar *searchBar;
@property (retain, nonatomic) NSString *searchText;

@end

@implementation GFPFriendPickerViewController

@synthesize searchBar = _searchBar;
@synthesize searchText = _searchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Invite Friends";
        self.searchBar = nil;
        
        // create an independent object
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self addSearchBarToFriendPickerView];
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(facebookViewControllerDoneWasPressed:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSearchBarToFriendPickerView
{
    if (self.searchBar == nil) {
        CGFloat searchBarHeight = 44.0;
        self.searchBar =
        [[UISearchBar alloc]
         initWithFrame:
         CGRectMake(0,0,
                    self.view.bounds.size.width,
                    searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask | UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        [self.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.tableView.frame = newFrame;
    }
}

- (void) handleSearch:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    [self updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self handleSearch:searchBar];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self handleSearch:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchText = nil;
    self.searchBar.text = @"";
    [self updateView];
    [searchBar resignFirstResponder];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    [[GFPFacebook sharedInstance] closeSession];
}


@end
