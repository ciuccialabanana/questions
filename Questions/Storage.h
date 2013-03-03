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
@property (nonatomic, strong) PFObject *partnerObject;
@property (nonatomic, strong) NSMutableDictionary *questionsPerCategoryTotalCount;



+ (id)sharedInstance;

- (void)storeUserAnswerWithAnswerId:(NSString *)answerId withQuestion:(PFObject *)question;
- (void)fetchUserInformationWithFacebookId:(NSString *)facebookId forUser:(User *)user  withPartner:(BOOL)partner;
- (void)fetchPartnerAnswers;
- (void)deleteCouple;
- (void)createCoupleToConfirmWithPartnerFacebookId:(NSString *)facebookId;
- (void)clearCurrentUser;
- (void)incrementUserAnsweredQuestionsPerCategory:(NSString *)categoryId;


@end
