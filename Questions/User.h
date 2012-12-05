//
//  User.h
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSMutableDictionary *questionAnswerMap;

+ (User *)userWithUserId:(NSString *)userId;
+ (User *)user;

- (id)initWithUserId:(NSString *)userId;


@end
