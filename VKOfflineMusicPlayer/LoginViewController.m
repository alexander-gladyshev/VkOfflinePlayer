//
//  LoginViewController.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "LoginViewController.h"
#import "VKUserManager.h"
#import "MPNotificationManager.h"

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.offlineButton.exclusiveTouch = YES;
}

-(IBAction)loginTap{
    [[VKUserManager sharedInstance] loginWithCompletion:^{
        [[VKUserManager sharedInstance] getUserInfoWithCompletion:^{
            if ([self.delegate respondsToSelector:@selector(setOfflineMode:)]){
                self.delegate.offlineMode = NO;
            }
            [[MPNotificationManager sharedInstance] showNotificationWithText:@"Success" withPositive:YES withCompletion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        } failedCompletion:^{
            [[MPNotificationManager sharedInstance] showNotificationWithText:@"Error Get Info" withPositive:NO];
        }];
    } failure:^{
        [[MPNotificationManager sharedInstance] showNotificationWithText:@"Error" withPositive:NO];
        NSLog(@"error");
    }];
}

- (IBAction)offlineTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(setOfflineMode:)]){
        self.delegate.offlineMode = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
