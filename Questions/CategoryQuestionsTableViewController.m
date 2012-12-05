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


@interface CategoryQuestionsTableViewController ()

@property (nonatomic, strong) PFObject *currentQuestion;
@property (nonatomic, strong) NSMutableDictionary *userAnswersDictionary;
@property (nonatomic, strong) NSMutableDictionary *partnerAnswersDictionary;
//@property (nonatomic, strong) AppDelegate *globalVariables;

@end

@implementation CategoryQuestionsTableViewController

//@synthesize categoryId = _categoryId;
//@synthesize currentQuestion = _currentQuestion;
//@synthesize userAnswersDictionary = _userAnswersDictionary;
//@synthesize partnerAnswersDictionary = _partnerAnswersDictionary;


- (void)viewDidLoad
{
    self.className = @"Questions";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 5;

//    self.globalVariables = [[UIApplication sharedApplication] delegate];

    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)createQuestionsAnswersDictionary:(NSArray *)result error:(NSError *)error
{
    self.userAnswersDictionary = [NSMutableDictionary dictionary];
    
    for (PFObject *answer in result) {
        for (PFObject *question in self.objects) {
            BOOL match = [(NSString *)[answer objectForKey:@"questionId"] compare:[question objectId]] == NSOrderedSame;
            if (match) {
                [self.userAnswersDictionary setObject:answer forKey:question.objectId];
            }
        }
    }
    [self.tableView reloadData];
    
}

- (void)getUserAnswers{
    
    //TODO: add filter on userId
    PFQuery *query = [PFQuery queryWithClassName:@"UserAnswer"];
    [query whereKey:@"categoryId" equalTo:self.categoryId];
    [query findObjectsInBackgroundWithTarget:self selector:@selector(createQuestionsAnswersDictionary:error:)];
    
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

- (void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    if (error) {
        NSLog(@"ERROR LAODING OBJECTS");
        return;
    }
    
    [self getUserAnswers];
    
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
    
    cell.questionLabel.text = [object objectForKey:@"question"];
    
    PFObject *answer = [self.userAnswersDictionary objectForKey:object.objectId];
    
    
    if (answer) {
        [cell.questionLabel setHidden:YES];
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
            destination.userAnswer = [self.userAnswersDictionary valueForKey:self.currentQuestion.objectId];
            destination.partnerAnswer = [self.partnerAnswersDictionary valueForKey:self.currentQuestion.objectId];
        }
    }
}

//reload table when user navigates back from the single question view
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self getPartnerAnswers];
    [self.tableView reloadData];
}


@end
