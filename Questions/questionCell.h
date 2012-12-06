//
//  questionCell.h
//  Questions
//
//  Created by Alberto Montagnese on 11/11/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *userCheckMark;
@property (weak, nonatomic) IBOutlet UIView *partnerCheckMark;

@end
