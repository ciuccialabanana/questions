//
//  CategoryQuesitonsTableViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 11/3/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "CategoryQuestionsTableViewController.h"
#import "QuestionDetailViewController.h"
#import "AppDelegate.h"
#import "questionCell.h"

@interface CategoryQuestionsTableViewController ()
    @property (nonatomic, strong) PFObject *currentQuestion;
    @property (nonatomic, strong) NSMutableDictionary *userAnswersDictionary;
    @property (nonatomic, strong) NSMutableDictionary *partnerAnswersDictionary;
    @property (nonatomic, strong) AppDelegate *globalVariables;


@end

@implementation CategoryQuestionsTableViewController

@synthesize categoryId = _categoryId;
@synthesize globalVariables = _globalVariables;
@synthesize currentQuestion = _currentQuestion;
@synthesize userAnswersDictionary = _userAnswersDictionary;
@synthesize partnerAnswersDictionary = _partnerAnswersDictionary;




- (void)viewDidLoad
{
    self.className = @"Questions";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 5;

    self.globalVariables = [[UIApplication sharedApplication] delegate];

    
    
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
    [query whereKey:@"userId" equalTo:self.globalVariables.userId];
    
    //TODO: add cache
    [query findObjectsInBackgroundWithTarget:self selector:@selector(createQuestionsAnswersDictionary:error:)];
    
}

- (void)getPartnerAnswers{
    
    //TODO: add filter on userId
    PFQuery *query = [PFQuery queryWithClassName:@"UserAnswer"];
    [query whereKey:@"categoryId" equalTo:self.categoryId];
    [query whereKey:@"userId" equalTo:self.globalVariables.partnerUserId];
    
    //TODO: add cache and add method
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!results){
            NSLog(@"No partner answers found");
        }else{
            self.partnerAnswersDictionary = [NSMutableDictionary dictionary];
            
            for (PFObject *answer in results) {
                for (PFObject *question in self.objects) {
                    BOOL match = [(NSString *)[answer objectForKey:@"questionId"] compare:[question objectId]] == NSOrderedSame;
                    if (match) {
                        [self.partnerAnswersDictionary setObject:answer forKey:question.objectId];
                        NSLog(@"Storing partner answer: %@ for question %@", answer, question.objectId );
                    }
                    
                }
            }
            [self.tableView reloadData];
            
        }
    }];
    
    
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query whereKey:@"categoryId" equalTo:self.categoryId];
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
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
    [self getPartnerAnswers];

    
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

    questionCell *cell = (questionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"questionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.questionText.text = [object objectForKey:@"question"];
    
    cell.userProfileImage.hidden = YES;
    cell.partnerProfileImage.hidden = YES;
    
    [self markCell:cell AsAnswered:object.objectId];
    
    return cell;
}

- (void)markCell: (questionCell *) cell AsAnswered:(NSString *)questionId{
    if ([self.userAnswersDictionary objectForKey:questionId]){
        cell.userProfileImage.hidden = NO;
        cell.userProfileImage.profileID = self.globalVariables.fbUserId;
    }
    if ([self.partnerAnswersDictionary objectForKey:questionId]){
        cell.partnerProfileImage.hidden = NO;
        cell.partnerProfileImage.profileID = self.globalVariables.fbPartnerId;
    }
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
    [self getUserAnswers];
    [self getPartnerAnswers];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}


@end
