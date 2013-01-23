//
//  Storage.h
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <Parse/Parse.h>

@interface Storage : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) PFObject *userObject;

+ (id)sharedInstance;

- (void)storeUserAnswerWithAnswerId:(NSString *)answerId withQuestion:(PFObject *)question;

- (void)fetchUserInformationWithFacebookId:(NSString *)facebookId;

@end
