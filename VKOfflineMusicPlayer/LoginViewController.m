//
//  LoginViewController.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "LoginViewController.h"
#import "VKUserManager.h"

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.offlineButton.exclusiveTouch = YES;
}

-(IBAction)loginTap{
    [[VKUserManager sharedInstance] loginWithCompletion:^{
        if ([self.delegate respondsToSelector:@selector(setOfflineMode:)]){
            self.delegate.offlineMode = NO;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^{
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
