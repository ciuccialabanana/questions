//
//  questionCell.h
//  Questions
//
//  Created by Alberto Montagnese on 11/11/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface questionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *partnerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *questionText;

@end
