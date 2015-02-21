//
//   LaunchScreen.h
//  VKOfflineMusicPlayer
//
//  Created by Alexander on 17/02/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DiamondActivityIndicator.h"

@interface LaunchScreenViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIVisualEffectView * blurView;

@property (nonatomic, weak) IBOutlet DiamondActivityIndicator * indicator;


@end
