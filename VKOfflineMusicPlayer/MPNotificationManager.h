//
//  MPNotificationManager.h
//  VKOfflineMusicPlayer
//
//  Created by Alexander on 14/02/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPNotificationManager : NSObject

-(void)showNotificationWithText:(NSString *)text
                   withPositive:(BOOL)positive;

-(void)showNotificationWithText:(NSString *)text
                   withPositive:(BOOL)positive
                 withCompletion:(void (^)(void))completion;

+(instancetype)sharedInstance;

@end
