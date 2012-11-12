//
//  questionCell.m
//  Questions
//
//  Created by Alberto Montagnese on 11/11/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import "questionCell.h"

@implementation questionCell

@synthesize questionText = _questionText;
@synthesize userProfileImage = _userProfileImage;
@synthesize partnerProfileImage = _partnerProfileImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
