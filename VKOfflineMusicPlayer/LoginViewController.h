//
//  LoginViewController.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerProtocol <NSObject>

@required
@property (nonatomic) BOOL offlineMode;

@end

@interface LoginViewController : UIViewController

- (IBAction)loginTap;
@property (weak, nonatomic) IBOutlet UIButton *offlineButton;
@property (nonatomic) id <LoginViewControllerProtocol> delegate;

@end
