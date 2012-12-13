//
//  QuestionCell.h
//  Questions
//
//  Created by Giuseppe Macri on 12/12/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *userCheckmark;
@property (weak, nonatomic) IBOutlet UIView *partnerCheckmark;


@end
