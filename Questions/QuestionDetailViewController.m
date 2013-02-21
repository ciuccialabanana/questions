//
//  QuestionDetailViewController.m
//  Questions
//
//  Created by Alberto Montagnese on 11/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Storage.h"

@interface QuestionDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (nonatomic, weak) User *user;
@property (nonatomic, weak) NSString *answerId;

@end

@implementation QuestionDetailViewController



- (void)viewDidLoad
{
    self.className = @"Answer";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 5;
    self.questionLabel.text = [self.question objectForKey:@"question"];
    
    [super viewDidLoad];
    
    self.user = [(Storage *)[Storage sharedInstance] user];
    PFObject *answer = [self.user.questionAnswerMap objectForKey:self.question.objectId];
    self.answerId = [answer objectForKey:@"answerId"];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    NSString *questionId = [self.question objectId];
    [query whereKey:@"questionId" equalTo:questionId];
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

    static NSString *CellIdentifier = @"AnswerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [object objectForKey:@"text"];


    if (self.answerId && [object.objectId compare:self.answerId] == NSOrderedSame) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.selected = NO;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *selectedAnswer = [self objectAtIndexPath:indexPath];

    self.answerId = selectedAnswer.objectId;
    
    [[Storage sharedInstance] storeUserAnswerWithAnswerId:self.answerId withQuestion:self.question];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    //go back to the list of questions
    [self.navigationController popViewControllerAnimated:YES];
}



@end
