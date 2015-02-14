//
//  MPNotificationManager.m
//  VKOfflineMusicPlayer
//
//  Created by Alexander on 14/02/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MPNotificationManager.h"
#import <CRToast.h>
#import "AppDelegate.h"

static MPNotificationManager * instance;

@interface MPNotificationManager ()

@end

@implementation MPNotificationManager


+(instancetype)sharedInstance{
    if (!instance){
        instance = [MPNotificationManager new];
    }
    return instance;
}


-(NSDictionary *)getOptionsWithText:(NSString *)text withPositive:(BOOL)positive{
    NSDictionary *options = @{
                              kCRToastTextKey : text,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : positive ? [UIColor colorWithRed:0.290 green:0.711 blue:0.467 alpha:1.000] : [UIColor colorWithRed:0.830 green:0.203 blue:0.183 alpha:1.000],
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight),
                              kCRToastStatusBarStyleKey : @(CRToastTypeNavigationBar)
                              };
    return options;
}

-(void)showNotificationWithText:(NSString *)text
                   withPositive:(BOOL)positive {
    [self showNotificationWithText:text
                      withPositive:positive
                    withCompletion:nil];
}

-(void)showNotificationWithText:(NSString *)text withPositive:(BOOL)positive withCompletion:(void (^)(void))completion{
    
    [CRToastManager showNotificationWithOptions:[self getOptionsWithText:text withPositive:positive] completionBlock:^{
        if (completion) completion();
    }];
}

@end
