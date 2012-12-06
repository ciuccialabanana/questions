//
//  questionCell.m
//  Questions
//
//  Created by Alberto Montagnese on 11/11/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "questionCell.h"

@implementation QuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self.userCheckMark setHidden:YES];
      [self.partnerCheckMark setHidden:YES];
    }
    return self;
}



@end
