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
        self.userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
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


@end
