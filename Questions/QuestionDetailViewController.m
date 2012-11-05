//
//  QuestionDetailViewController.m
//  Questions
//
//  Created by Alberto Montagnese on 11/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "QuestionDetailViewController.h"

@interface QuestionDetailViewController ()

    @property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation QuestionDetailViewController

@synthesize question = _question;
@synthesize answer = _answer;


- (void)viewDidLoad
{
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
    
    if ([object.objectId compare:[self.answer valueForKey:@"answerId"]] == NSOrderedSame) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *selectedAnswer = [self objectAtIndexPath:indexPath];

    //store the selected answer
    if (self.answer){
        //the user has previously answered to this question
        [self.answer setObject:selectedAnswer.objectId forKey:@"answerId"];
        [self.answer saveInBackground];
    }else{
        //first time the user answers, a new record in UserAnswer needs to be created
        self.answer = [PFObject objectWithClassName:@"UserAnswer"];
        [self.answer setObject:selectedAnswer.objectId forKey:@"answerId"];
        [self.answer setObject:[self.question valueForKey:@"categoryId"] forKey:@"categoryId"];
        [self.answer setObject:self.question.objectId forKey:@"questionId"];
        //TODO: set userId
        //[self.answer setObject:user.id forKey:@"userId"];
        
        [self.answer saveInBackground];
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
