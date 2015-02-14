//
//  MPOnlinePlaylistViewController.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface MPOnlinePlaylistViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, LoginViewControllerProtocol>
@property (weak, nonatomic) IBOutlet UIImageView * avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel * nickNameLabel;
@property (weak, nonatomic) IBOutlet UIView *loaderIndicatorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editListButton;

@property (strong, nonatomic) IBOutlet UIView *emptyListView;

#pragma mark LoginViewControllerProtocol

@property (nonatomic) BOOL offlineMode;

@end
