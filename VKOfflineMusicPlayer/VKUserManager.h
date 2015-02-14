//
//  VKUserManager.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk.h>
#import "UserMO+Actions.h"

typedef void (^MPCompletionBlock)();

@interface VKUserManager : NSObject <VKSdkDelegate>

-(void)login;
-(void)loginWithCompletion:(MPCompletionBlock)completion
                   failure:(MPCompletionBlock)failedBlock;

@property (nonatomic, strong) UserMO * user;

+(VKUserManager *)sharedInstance;

-(void)getUserInfoWithCompletion:(MPCompletionBlock)completion
                failedCompletion:(MPCompletionBlock)failedCompletion;
-(NSString *)getFullUserName;

-(void)getUserPlaylistWithCompletion:(MPCompletionBlock)completion failedCompletion:(MPCompletionBlock)failedCompletion;


@end
