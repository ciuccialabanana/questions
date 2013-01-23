//
//  User.m
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)userWithUserId:(NSString *)userId
{
    return [[User alloc] initWithUserId:userId];
}

+ (User *)user
{    
    return [[User alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userId = [[NSUUID UUID] UUIDString];
        self.questionAnswerMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithUserId:(NSString *)userId
{
    self = [self init];
    if (self) {
        self.userId = userId;
    }
    
    return self;
}

- (void)clear
{
    self.userId = nil;
    self.facebookId = nil;
    [self.questionAnswerMap removeAllObjects];
}

- (void)updateWithDictionary:(NSDictionary *)dictionary
{
    if ([dictionary objectForKey:USERID]) {
        self.userId = [dictionary objectForKey:USERID];
    }
    
    if ([dictionary objectForKey:FACEBOOKID]) {
        self.facebookId = [dictionary objectForKey:FACEBOOKID];
    }
}

@end
