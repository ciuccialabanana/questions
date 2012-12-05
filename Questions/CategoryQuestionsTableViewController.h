//
//  CategoryQuesitonsTableViewController.h
//  Questions
//
//  Created by Giuseppe Macri on 11/3/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Parse/Parse.h>

@interface CategoryQuestionsTableViewController : PFQueryTableViewController

@property (nonatomic, strong) NSString *categoryId;

@end
