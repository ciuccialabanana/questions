//
//  Storage.m
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "Storage.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation Storage

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _instance = nil;
    dispatch_once(&pred, ^{
        _instance = [[self alloc] init]; // or some other init method
    });
    return _instance;
}


- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userId = [defaults objectForKey:USERID];

        if (!userId) {
            // create a new user
            self.user = [User user];
            [self storeInfoToServerForUser:self.user];
        } else {
            self.user = [User userWithUserId:userId];
            // fetch user info from parse
            [self fetchUserAnswersForUser:self.user];
        }
        
        [self initCategoryQuestionsTotalCounts];
        
        [defaults setObject:self.user.userId forKey:USERID];
        if ([defaults synchronize]) {
            NSLog(@"saved");
            // TODO: save user to parse
        } else {
            NSLog(@"error saving");
        }
        
        
    }
    return self;
}

- (void)initCategoryQuestionsTotalCounts{
    self.questionsPerCategoryTotalCount = [NSMutableDictionary dictionary];
    //TODO: count items for each category
    PFQuery *allCatQuery = [PFQuery queryWithClassName:@"Categories"];
    [allCatQuery findObjectsInBackgroundWithBlock:^(NSArray *categories, NSError *error) {
        if (!error) {
            for (PFObject *category in categories){
                PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
                [query whereKey:CATEGORYID equalTo:category.objectId];
                [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                    if (!error) {
                        [self.questionsPerCategoryTotalCount setObject:[NSNumber numberWithInt:count] forKey:category.objectId];
                    }else{
                        NSLog(@"Error while fetching total count of questions for each category");
                    }
                }];
            }
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)storeInfoToServerForUser:(User *)user
{
    PFObject *userObject = [PFObject objectWithClassName:USER];
    [userObject setObject:user.userId forKey:USERID];
    if (user.facebookId) {
        [userObject setObject:user.facebookId forKey:FACEBOOKID];
    }
    [userObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.userObject = userObject;
        } else {
            NSLog(@"Not possible to save the current user");
        }
    }];
}

- (void)storeUserAnswerWithAnswerId:(NSString *)answerId withQuestion:(PFObject *)question
{
    PFObject *answer = [self.user.questionAnswerMap objectForKey:question.objectId];
    
    if (!answer) {
        answer = [PFObject objectWithClassName:USERANSWER];
    }
    
    NSString *categoryId = [question valueForKey:CATEGORYID];
    
    [answer setObject:answerId forKey:ANSWERID];
    [answer setObject:categoryId forKey:CATEGORYID];
    [answer setObject:question.objectId forKey:QUESTIONID];
    [answer setObject:self.user.userId forKey:USERID];
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"object saved");
        }
    }];
    
    [self.user.questionAnswerMap setObject:answer forKey:question.objectId];
}

// TODO: REFACTOR THIS TO RETURN USER OBJECT

- (void)fetchUserInformationWithFacebookId:(NSString *)facebookId forUser:(User *)user
{
    PFQuery *query = [PFQuery queryWithClassName:USER];
    [query whereKey:FACEBOOKID equalTo:facebookId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] == 0) {
                user.facebookId = facebookId;
                [self storeInfoToServerForUser:user];
            } else if ([objects count] == 1){
                PFObject *userObject = [objects objectAtIndex:0];
                NSString *userId = [userObject objectForKey:USERID];
                NSString *facebookId = [userObject objectForKey:FACEBOOKID];
                [user clear];
                NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userId, USERID, facebookId, FACEBOOKID, nil];
                [user updateWithDictionary:dictionary];
                
                // refactor this to store the current user information // main or partner
                [self fetchUserAnswersForUser:self.user];
            } else {
                NSLog(@"Too many users with same facebook id. ERROR!");
            }
        }
        
    }];
}


- (void)fetchPartnerInformation
{
    PFQuery *query = [PFQuery queryWithClassName:COUPLE];
    [query whereKey:RECEIVER equalTo:self.user.facebookId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] > 1) {
                NSLog(@"Too many couples for the following users. ERROR!");
            } else if ([objects count] == 1) {
                // TODO: FETCH PARTNER INFORMATION using facebook sdk
                PFObject *coupleObject = [objects lastObject];
                [FBRequestConnection startWithGraphPath:[coupleObject objectForKey:SENDER] completionHandler:^(FBRequestConnection *connection, id<FBGraphUser> result, NSError *error) {
                    
                }];
                // TODO: FETCH PARTNER ANSWERS using parse sdk
            }
        }
    }];
}
 
- (void)fetchUserAnswersForUser:(User *)user
{
    
    PFQuery *query = [PFQuery queryWithClassName:USERANSWER];
    [query whereKey:@"userId" equalTo:self.user.userId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            user.userAnsweredQuestionsPerCategory = [NSMutableDictionary dictionary];
            
            [user.questionAnswerMap removeAllObjects];
            for (PFObject *answer in objects) {
                [user.questionAnswerMap setObject:answer forKey:[answer objectForKey:QUESTIONID]];
                
                NSNumber *answeredQuestionsCount = [user.userAnsweredQuestionsPerCategory objectForKey:[answer objectForKey:CATEGORYID]];
                int answeredQuestionsCountInt = 1;
                if (answeredQuestionsCount != nil){
                    answeredQuestionsCountInt = [answeredQuestionsCount intValue] + 1;
                }
                answeredQuestionsCount = [NSNumber numberWithInt:answeredQuestionsCountInt];
                
                [user.userAnsweredQuestionsPerCategory setObject:answeredQuestionsCount forKey:[answer objectForKey:CATEGORYID]];
            }
            NSString *notificationName = @"USER_ANSWERS_NOTIFICATION";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:nil];
        }
        
    }];
}

- (void)createCoupleToConfirmWithPartnerFacebookId:(NSString *)facebookId
{
    PFObject *coupleObject = [PFObject objectWithClassName:COUPLE];
    [coupleObject setObject:self.user.facebookId forKey:SENDER];
    [coupleObject setObject:facebookId forKey:RECEIVER];
    [coupleObject setObject:[NSNumber numberWithBool:NO] forKey:VALID];
    [coupleObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Couple was created");
        } else {
            // TODO: CHECK THE ERROR
        }
    }];
}

- (void)clearCurrentUser
{
    [self.user clear];
}


@end
