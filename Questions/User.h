//
//  User.h
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERID @"user_id"
#define USER_QUESTION_ANSWER_MAP @"question_answer_map"
#define FACEBOOKID @"facebook_id"

@interface User : NSObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *facebookId;

@property (nonatomic, strong) NSMutableDictionary *questionAnswerMap;

+ (User *)userWithUserId:(NSString *)userId;
+ (User *)user;

- (id)initWithUserId:(NSString *)userId;
- (void)clear;
- (void)updateWithDictionary:(NSDictionary *)dictionary;


@end
