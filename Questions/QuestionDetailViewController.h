//
//  QuestionDetailViewController.h
//  Questions
//
//  Created by Alberto Montagnese on 11/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Parse/Parse.h>


@interface QuestionDetailViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *question;

@end
