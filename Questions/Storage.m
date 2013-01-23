//
//  Storage.m
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "Storage.h"

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
        } else {
            // fetch user info
            self.user = [User userWithUserId:userId];
        }
        [defaults setObject:self.user.userId forKey:USERID];
        if ([defaults synchronize]) {
            NSLog(@"saved");
            // TODO: save user to parse
        } else {
            NSLog(@"error saving");
        }
        
        
        // fetch user answers
        [self fetchUserAnswers];
        
    }
    return self;
}


- (void)storeUserToServer
{
    PFObject *userObject = [PFObject objectWithClassName:@"User"];
    [userObject setObject:self.user.userId forKey:USERID];
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
    PFObject *answer = [self.user.questionAnswerMap objectForKey:question.objectId];;
    
    if (!answer) {
        answer = [PFObject objectWithClassName:@"UserAnswer"];
    }
    
    [answer setObject:answerId forKey:@"answerId"];
    [answer setObject:[question valueForKey:@"categoryId"] forKey:@"categoryId"];
    [answer setObject:question.objectId forKey:@"questionId"];
    [answer setObject:self.user.userId forKey:USERID];
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"object saved");
        }
    }];
    
    [self.user.questionAnswerMap setObject:answer forKey:question.objectId];
}


- (void)fetchUserInformationWithFacebookId:(NSString *)facebookId
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKey:FACEBOOKID equalTo:facebookId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if ([objects count] == 0) {
                self.user.facebookId = facebookId;
                [self storeUserToServer];
            } else if ([objects count] == 1){
                PFObject *userObject = [objects objectAtIndex:0];
                NSString *userId = [userObject objectForKey:USERID];
                NSString *facebookId = [userObject objectForKey:FACEBOOKID];
                [self.user clear];
                NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userId, USERID, facebookId, FACEBOOKID, nil];
                [self.user updateWithDictionary:dictionary];
                [self fetchUserAnswers];
                // TODO: fetch user answer information
            } else {
                NSLog(@"Too many users with same facebook id. ERROR!");
            }
        }
        
    }];
}



- (void)fetchUserAnswers
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserAnswer"];
    [query whereKey:@"userId" equalTo:self.user.userId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self.user.questionAnswerMap removeAllObjects];
            for (PFObject *answer in objects) {
                [self.user.questionAnswerMap setObject:answer forKey:[answer objectForKey:@"questionId"]];
            }
            NSString *notificationName = @"USER_ANSWERS_NOTIFICATION";
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:nil];
        }
        
    }];
}



@end
