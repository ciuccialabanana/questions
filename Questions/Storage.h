//
//  Storage.h
//  Questions
//
//  Created by Giuseppe Macri on 12/4/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Storage : NSObject

@property (nonatomic, strong) User *user;

+ (id)sharedInstance;

@end
