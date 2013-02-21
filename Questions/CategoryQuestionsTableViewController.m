//
//  CategoryQuesitonsTableViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 11/3/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "CategoryQuestionsTableViewController.h"
#import "QuestionDetailViewController.h"
#import "QuestionCell.h"
#import "User.h"
#import "Storage.h"

@interface CategoryQuestionsTableViewController ()

@property (nonatomic, strong) PFObject *currentQuestion;

@property (nonatomic, weak) User *user;

@end

@implementation CategoryQuestionsTableViewController


- (void)viewDidLoad
{
    self.className = @"Questions";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 5;
    
    [super viewDidLoad];
    
    self.user = [(Storage *)[Storage sharedInstance] user];
    
    NSString *notificationName = @"USER_ANSWERS_NOTIFICATION";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAnswersNotification:) name:notificationName object:nil];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:@"categoryId" equalTo:self.categoryId];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}


- (void)userAnswersNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
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
    
    static NSString *CellIdentifier = @"QuestionCell";
    
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.questionLabel.text = [object objectForKey:@"question"];
    
    PFObject *answer = [self.user.questionAnswerMap objectForKey:object.objectId];
    
    if (answer) {
        [cell.userCheckmark setHidden:NO];
    } 
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentQuestion = [self objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"goToQuestionDetail" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier compare:@"goToQuestionDetail"] == NSOrderedSame) {
        NSLog(@"controller: %@", segue.destinationViewController);
        if ([segue.destinationViewController isKindOfClass:[QuestionDetailViewController class]]) {
            QuestionDetailViewController *destination = segue.destinationViewController;
            destination.question = self.currentQuestion;
        }
    }
}

//reload table when user navigates back from the single question view
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.view.backgroundColor = [UIColor clearColor];
}


@end
