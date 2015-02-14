//
//  MPSongViewCell.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MPSongViewCell.h"

const float downloadMode = 7;
const float cachedMode = -50;
@interface MPSongViewCell ()

@property (nonatomic, strong) SongMO * song;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end

@implementation MPSongViewCell


-(void)fillWithSong:(SongMO *)song{
    self.song = song;
    self.songTitleLabel.text = [song fullName];
    self.durationLabel.text = [NSString stringWithFormat:@"%@",song.duration];
    self.rightConstraint.constant = [song isCached] ? cachedMode : downloadMode;
    NSLog(@"%@  --- %@", [song isCached] ? @"YES" : @"NO",song.title);
}

- (IBAction)downloadSong:(id)sender {
    [self.song downloadSongToHard];
    NSLog(@"download %@",self.song.title);
}
@end
