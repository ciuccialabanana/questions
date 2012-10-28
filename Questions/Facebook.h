//
//  Facebook.h
//  Questions
//
//  Created by Giuseppe Macri on 10/27/12.
//  Copyright (c) 2012 FJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol facebookDelegate

- (void)facebookLoginSuccess;
- (void)facebookLoginFailed;

@end


@interface Facebook : NSObject

@property (nonatomic, weak) id<facebookDelegate> delegate;


+ (id)sharedInstance;

- (void)openSession;
- (void)closeSession;
- (BOOL)checkSession;

@end
