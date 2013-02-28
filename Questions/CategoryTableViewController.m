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

@property (nonatomic, assign) NSInteger lastCompletedCategoryRowNum;

@end


@implementation CategoryTableViewController

- (void)viewDidLoad
{
    self.className = @"Categories";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.objectsPerPage = 5;
    self.lastCompletedCategoryRowNum = -1;
    
    
    self.storage = [Storage sharedInstance];
    
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
   // self.view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.cellCategoryLabel.text = [object objectForKey:@"name"];
    
    
    //answered questions count
    NSString *answeredQuestionsCount = @"0";
    cell.cellAnsweredQuestionPerCategoryCount = 0;
    if([self.storage.user.userAnsweredQuestionsPerCategory objectForKey:[object objectId]] != nil){
        cell.cellAnsweredQuestionPerCategoryCount = [self.storage.user.userAnsweredQuestionsPerCategory objectForKey:object.objectId];
        answeredQuestionsCount = [cell.cellAnsweredQuestionPerCategoryCount stringValue];
    }
    
    cell.cellTotalQuestionPerCategoryCount = [self.storage.questionsPerCategoryTotalCount objectForKey:object.objectId];
    NSString *totalQuestionsCount = [cell.cellTotalQuestionPerCategoryCount stringValue];
    
    cell.cellSecondaryLabel.text = [[answeredQuestionsCount stringByAppendingString:@" / "] stringByAppendingString:totalQuestionsCount];
    
                                                            
    //gaming logic, hide cell if previous category is not completed
    if (cell.cellAnsweredQuestionPerCategoryCount == cell.cellTotalQuestionPerCategoryCount){
        self.lastCompletedCategoryRowNum = indexPath.row;
    }

    if (indexPath.row > 0 && indexPath.row > self.lastCompletedCategoryRowNum + 1){
        [cell setHidden:YES];
    }

    
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
