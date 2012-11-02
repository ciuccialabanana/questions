//
//  CategoriesViewController.m
//  Questions
//
//  Created by Alberto Montagnese on 10/31/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "Parse/Parse.h"


@interface CategoryTableViewController ()
    @property (nonatomic, strong) NSMutableArray *categories;


@end


@implementation CategoryTableViewController
@synthesize categories=_categories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.categories = [[NSMutableArray alloc] init];
    [super viewDidLoad];    

    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    NSArray* objects = [query findObjects] ;
            
    for (int i = 0; i < objects.count; i++) {
        PFObject *category = objects[i];
        NSString *categoryName = [category objectForKey:@"name"];
        NSLog(@"category: %@", categoryName);
        [self.categories addObject:categoryName];
    }


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"categoryTableCell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.categories objectAtIndex: [indexPath row]];
    cell.detailTextLabel.text = @"1 - 50";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
}

@end
