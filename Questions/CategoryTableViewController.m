//
//  CategoriesViewController.m
//  Questions
//
//  Created by Alberto Montagnese on 10/31/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "CategoryQuestionsTableViewController.h"
#import "CategoryCell.h"
#import "Storage.h"


@interface CategoryTableViewController ()

@property (nonatomic, strong) NSString *currentCategoryId;

@property (nonatomic, weak) Storage *storage;

@end


@implementation CategoryTableViewController

- (void)viewDidLoad
{
    self.className = @"Categories";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.objectsPerPage = 5;
    
    
    self.storage = [Storage sharedInstance];
    
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.cellCategoryLabel.text = [object objectForKey:@"name"];
    
    
    //answered questions count
    NSString *answeredQuestionsCount = @"0";
    if([self.storage.user.userAnsweredQuestionsPerCategory objectForKey:[object objectId]] != nil){
        answeredQuestionsCount = [[self.storage.user.userAnsweredQuestionsPerCategory objectForKey:object.objectId] stringValue];
    }
    NSString *totalQuestionsCount = [[self.storage.questionsPerCategoryTotalCount objectForKey:object.objectId] stringValue];
    
    cell.cellSecondaryLabel.text = [[answeredQuestionsCount stringByAppendingString:@" / "] stringByAppendingString:totalQuestionsCount];
    
    
//    self.storage.user.questionAnswerMap
    
      //cell.cellBackgroundImage.image = UIImage.;
      //cell.cellHeaderImage.image = "";
//    cell. = 
  //  cell.detailTextLabel.text = @"1 - 50";
    
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
