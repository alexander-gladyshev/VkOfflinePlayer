//
//   LaunchScreen.m
//  VKOfflineMusicPlayer
//
//  Created by Alexander on 17/02/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "VKUserManager.h"

@implementation LaunchScreenViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self.indicator startAnimating];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self animateView];

}


-(void)animateView{
    
    
    [self performSelector:@selector(tryAutorize) withObject:nil afterDelay:10];
//    [UIView animateWithDuration:10 animations:^{
//        self.indicator.alpha = 1;
//        self.blurView.alpha = 1;
//    } completion:^(BOOL finished) {
//        [self tryAutorize];
//    }];
}

-(void)tryAutorize{
    [[VKUserManager sharedInstance] getUserInfoWithCompletion:^{
        [self performSegueWithIdentifier:@"ShowPlayListSegue" sender:self];
    } failedCompletion:^{
        [self performSegueWithIdentifier:@"ShowPlayListSegue" sender:self];
    }];

}

@end
