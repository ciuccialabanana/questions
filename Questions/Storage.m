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
        NSString *userId = [defaults objectForKey:@"userId"];
        if (!userId) {
            // create a new user
            self.user = [User user];
        } else {
            // create a new user with the userId
            self.user = [User userWithUserId:userId];
            self.user.questionAnswerMap = [defaults objectForKey:@"questionAnswerMap"];
        }
    }
    return self;
}



@end
