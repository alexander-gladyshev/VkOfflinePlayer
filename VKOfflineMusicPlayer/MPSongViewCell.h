//
//  MPSongViewCell.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SongMO+Actions.h"



@interface MPSongViewCell : UITableViewCell

-(void)fillWithSong:(SongMO *)song;
@property (weak, nonatomic) IBOutlet UIButton *downloadSongButton;

@end
