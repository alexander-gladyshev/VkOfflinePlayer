//
//  VKUserManager.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "VKUserManager.h"
#import "AppDelegate.h"
#import "SongMO+Actions.h"

static VKUserManager * instance;

@interface VKUserManager ()

@property (nonatomic, strong) MPCompletionBlock successBlock;
@property (nonatomic, strong) MPCompletionBlock failedBlock;

@end

@implementation VKUserManager

+(VKUserManager *)sharedInstance{
    if (!instance){
        instance = [VKUserManager new];
        [instance startSession];
    }
    return instance;
}

-(void)startSession{
    [VKSdk initializeWithDelegate:instance andAppId:@"4750190"];
    if ([VKSdk wakeUpSession])
    {
        NSLog(@"START SESSION");
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"VKToken"] &&
            [[NSUserDefaults standardUserDefaults] objectForKey:@"VKTUserId"] &&
            [[NSUserDefaults standardUserDefaults] objectForKey:@"VKSecret"]){
            
            
            NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKToken"];
            NSString * userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKTUserId"];
            NSString * secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKSecret"];
            
            VKAccessToken * accessToken = [VKAccessToken tokenWithToken:token secret:secret userId:userId];
            [VKSdk setAccessToken:token];
        }
        //Start working
    }
}

#pragma mark Login

-(void)login{
    [self loginWithCompletion:nil failure:nil];

}

-(void)loginWithCompletion:(MPCompletionBlock)completion failure:(MPCompletionBlock)failedBlock{
    self.successBlock = completion;
    self.failedBlock = failedBlock;
    [VKSdk authorize:@[VK_PER_AUDIO]];
}

-(void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{
    [[NSUserDefaults standardUserDefaults] setObject:newToken.accessToken forKey:@"VKToken"];
    [[NSUserDefaults standardUserDefaults] setObject:newToken.userId forKey:@"VKTUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:newToken.secret forKey:@"VKSecret"];
    NSLog(@"SUCCESS!!!");
    [self callCompletionWithSuccess:YES];
}

-(void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    NSLog(@"FAILED!!!");
    [self callCompletionWithSuccess:NO];
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    NSLog(@"vkSdkShouldPresentViewController");
}

-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    NSLog(@"vkSdkShouldPresentViewController");
    [self callCompletionWithSuccess:NO];
}

-(void)vkSdkNeedCaptchaEnter:(VKError*) captchaError
{
    VKCaptchaViewController * vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController];
}

#pragma mark Information

-(void)getUserInfoWithCompletion:(MPCompletionBlock)completion failedCompletion:(MPCompletionBlock)failedCompletion{
    VKRequest * userRequest = [[VKApi users] get];
    [userRequest executeWithResultBlock:^(VKResponse *response) {
        if (!self.user){
            self.user = [UserMO getUserWithId:response.json[0][@"id"] withContext:[AppDelegate appDelegate].managedObjectContext];
        }
        self.user.firstName     = response.json[0][@"first_name"];
        self.user.lastName      = response.json[0][@"last_name"];
        self.user.isOwner = YES;
        [[AppDelegate appDelegate] saveContext];
        if (completion) completion();
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        if (failedCompletion) failedCompletion();
    }];
}

-(NSString *)getFullUserName{
    return [self.user.firstName stringByAppendingFormat:@" %@",self.user.lastName];
}

#pragma mark Songs

-(void)getUserPlaylistWithCompletion:(MPCompletionBlock)completion failedCompletion:(MPCompletionBlock)failedCompletion{
    VKRequest * songsRequest = [VKApi requestWithMethod:@"audio.get" andParameters:@{@"owner_id" : self.user.identifier} andHttpMethod:@"GET"];
    [songsRequest executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"%@",response.json);
        [SongMO parseSongsJSON:response.json withContext:[AppDelegate appDelegate].managedObjectContext];
        if (completion) completion();
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        if (failedCompletion) failedCompletion();
    }];
}

-(void)callCompletionWithSuccess:(BOOL)success{
    if (success){
        if (self.successBlock) self.successBlock();
    }else{
        if (self.failedBlock) self.failedBlock();
    }
    self.successBlock = self.failedBlock = nil;
}


@end
