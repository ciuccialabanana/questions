//
//  User.h
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>


// Class names
#define USER @"user"
#define USERANSWER @"UserAnswer"
#define COUPLE @"Couple"


// Field names
#define USERID @"userId"
#define USER_QUESTION_ANSWER_MAP @"question_answer_map"
#define FACEBOOKID @"facebookId"
#define ANSWERID @"answerId"
#define CATEGORYID @"categoryId"
#define QUESTIONID @"questionId"
#define SENDER @"sender"
#define RECEIVER @"receiver"
#define VALID @"valid"

@interface User : NSObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *facebookId;

@property (nonatomic, strong) NSMutableDictionary *questionAnswerMap;

@property (nonatomic, strong) NSMutableDictionary *userAnsweredQuestionsPerCategory;

+ (User *)userWithUserId:(NSString *)userId;
+ (User *)user;

- (id)initWithUserId:(NSString *)userId;
- (void)clear;
- (void)updateWithDictionary:(NSDictionary *)dictionary;


@end
