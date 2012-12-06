//
//  CategoriesViewController.m
//  Questions
//
//  Created by Alberto Montagnese on 10/31/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "CategoryQuestionsTableViewController.h"



@interface CategoryTableViewController ()

@property (nonatomic, strong) NSString *currentCategoryId;

@end


@implementation CategoryTableViewController

- (void)viewDidLoad
{
    self.className = @"Categories";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.objectsPerPage = 5;
    
    
    [super viewDidLoad];

}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"categoryTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = @"1 - 50";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentCategoryId = [[self objectAtIndexPath:indexPath] objectId];
    [self performSegueWithIdentifier:@"goToCategoryQuestions" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"goToCategoryQuestions"] == NSOrderedSame) {
        if ([segue.destinationViewController isKindOfClass:[CategoryQuestionsTableViewController class]]) {
            CategoryQuestionsTableViewController *destination = segue.destinationViewController;
            destination.categoryId = self.currentCategoryId;
        }
        
    }
}


@end
