//
//  QuestionDetailViewController.m
//  Questions
//
//  Created by Alberto Montagnese on 11/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "AppDelegate.h"

@interface QuestionDetailViewController ()

    @property (weak, nonatomic) IBOutlet UILabel *questionLabel;
//    @property (nonatomic, strong) AppDelegate *globalVariables;

@end

@implementation QuestionDetailViewController

@synthesize question = _question;
@synthesize userAnswer = _userAnswer;
@synthesize partnerAnswer = _partnerAnswer;
//@synthesize globalVariables = _globalVariables;

- (void)viewDidLoad
{
//    self.globalVariables = [[UIApplication sharedApplication] delegate];
    self.className = @"Answer";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 5;
    self.questionLabel.text = [self.question objectForKey:@"question"];
    
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [object objectForKey:@"text"];
    
    if ([object.objectId compare:[self.userAnswer valueForKey:@"answerId"]] == NSOrderedSame) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if ([object.objectId compare:[self.partnerAnswer valueForKey:@"answerId"]] == NSOrderedSame) {
        //TODO mark as answered by partner
        [cell setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
        NSLog(@" Partner Answer: %@", self.partnerAnswer);
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *selectedAnswer = [self objectAtIndexPath:indexPath];

    //store the selected answer
    if (self.userAnswer){
        //the user has previously answered to this question
        [self.userAnswer setObject:selectedAnswer.objectId forKey:@"answerId"];
        [self.userAnswer saveInBackground];
    }else{
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        //first time the user answers, a new record in UserAnswer needs to be created
        self.userAnswer = [PFObject objectWithClassName:@"UserAnswer"];
        [self.userAnswer setObject:selectedAnswer.objectId forKey:@"answerId"];
        [self.userAnswer setObject:[self.question valueForKey:@"categoryId"] forKey:@"categoryId"];
        [self.userAnswer setObject:self.question.objectId forKey:@"questionId"];
        [self.userAnswer setObject:appDelegate.userId forKey:@"userId"];
        
        [self.userAnswer saveInBackground];
    }
    
    
    //go back to the list of questions
    [self.navigationController popViewControllerAnimated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.accessoryType != UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    
}


@end
