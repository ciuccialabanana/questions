//
//  CategoryCell.h
//  Questions
//
//  Created by Farid Hosseini on 2/6/13.
//  Copyright (c) 2013 FJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellHeaderImage;
@property (weak, nonatomic) IBOutlet UIImageView *cellBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *cellCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellSecondaryLabel;

@property (nonatomic, weak) NSNumber *cellAnsweredQuestionPerCategoryCount;
@property (nonatomic, weak) NSNumber *cellTotalQuestionPerCategoryCount;

@end
