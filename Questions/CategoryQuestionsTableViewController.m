//
//  CategoryQuesitonsTableViewController.m
//  Questions
//
//  Created by Giuseppe Macri on 11/3/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "CategoryQuestionsTableViewController.h"
#import "QuestionDetailViewController.h"

@interface CategoryQuestionsTableViewController ()
    @property (nonatomic, strong) PFObject *currentQuestion;
    @property (nonatomic, strong) NSMutableDictionary *questionsAnswersDictionary;
@end

@implementation CategoryQuestionsTableViewController

@synthesize categoryId = _categoryId;
@synthesize currentQuestion = _currentQuestion;
@synthesize questionsAnswersDictionary = _dictionary;



- (void)viewDidLoad
{
    self.className = @"Questions";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 5;
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void) createQuestionsAnswersDictionary{
    NSArray *answers = [self getUserAnswers];
    self.questionsAnswersDictionary = [NSMutableDictionary dictionary];
    
    for (PFObject *answer in answers) {
        for (PFObject *question in self.objects) {
            BOOL match = [(NSString *)[answer objectForKey:@"questionId"] compare:[question objectId]] == NSOrderedSame;
            if (match) {

                [self.questionsAnswersDictionary setObject:answer forKey:question.objectId];
            }
            
        }
        
    }
}

- (NSArray *)getUserAnswers{
    
    //TODO: add filter on userId
    PFQuery *query = [PFQuery queryWithClassName:@"UserAnswer"];
    [query whereKey:@"categoryId" equalTo:self.categoryId];
    
    //TODO: add cache
    return [query findObjects];


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
    
    
    //TODO IMPORTANT: put this when once and for all when the table is loaded. This way it creates a dictionary for
    //all the cells of the table. No need of doing this, I don't know at which point I m sure the table is loaded
    [self createQuestionsAnswersDictionary];

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"question"];
    cell.detailTextLabel.text = @"Complete/To do";
    
    [self markCell:cell AsAnswered:object.objectId];
    
    return cell;
}

- (void)markCell: (UITableViewCell *) cell AsAnswered:(NSString *)questionId{
    if ([self.questionsAnswersDictionary objectForKey:questionId]){
        //put a checkmark on answered questions (if exists a value associated to that key)
        //TODO: substitute this with fb pic
        cell.imageView.image = [UIImage imageNamed:@"Icon-72.png"];
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
            destination.answer = [self.questionsAnswersDictionary valueForKey:self.currentQuestion.objectId];
        }
        
    }
}


@end
