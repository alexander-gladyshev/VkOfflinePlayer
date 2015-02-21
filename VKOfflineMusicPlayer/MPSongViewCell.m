//
//  MPSongViewCell.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MPSongViewCell.h"
#import "UCZProgressView.h"
#import "MPAudioPlayer.h"
#import "AppDelegate.h"
#import <NAKPlaybackIndicatorView.h>

const float downloadMode = 7;
const float cachedMode = -50;

const float playMode = 12;
const float stopMode = playMode - 33;

@interface MPSongViewCell ()

@property (nonatomic, strong) SongMO * song;
@property (weak, nonatomic) IBOutlet UILabel * songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel * durationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * leftConstraint;
@property (nonatomic, strong) IBOutlet UCZProgressView * progressView;
@property (nonatomic, strong) IBOutlet NAKPlaybackIndicatorView * playBackView;

@end

@implementation MPSongViewCell


-(void)prepareForReuse{
    if (self.song){
        AFHTTPRequestOperation * operation = [[MPAudioPlayer sharedInstance] downloadOperationForSong:self.song];
        if (operation){
//            [operation setDownloadProgressBlock:nil];
            self.progressView.progress = 0;
            self.progressView.indeterminate = NO;
        }
    }
}

-(void)fillWithSong:(SongMO *)song{
    self.song = song;
    self.songTitleLabel.text = [song fullName];
    self.durationLabel.text = [NSString stringWithFormat:@"%@",song.duration];
    self.rightConstraint.constant = [song isRealCached] ? cachedMode : downloadMode;
    
    if ([[MPAudioPlayer sharedInstance] isCurrentSong:self.song]){
        self.leftConstraint.constant = playMode;
        switch ([MPAudioPlayer sharedInstance].state) {
            case MPAudioPlayerStatePlaying:
                self.playBackView.state = NAKPlaybackIndicatorViewStatePlaying;
                break;
            case MPAudioPlayerStatePaused:
                self.playBackView.state = NAKPlaybackIndicatorViewStatePaused;
                break;
            case MPAudioPlayerStateStoped:
                self.playBackView.state = NAKPlaybackIndicatorViewStateStopped;
                break;
            default:
                break;
        }
    }else{
        self.leftConstraint.constant = stopMode;
        self.playBackView.state = NAKPlaybackIndicatorViewStateStopped;
    }
    AFHTTPRequestOperation * operation = [[MPAudioPlayer sharedInstance] downloadOperationForSong:self.song];
    self.downloadSongButton.hidden = [song isRealCached] || operation;
    self.progressView.indeterminate = ![song isRealCached] && operation;
    if (operation){
        [operation setDownloadProgressBlock:[self getDownloadProgressBlock]];
    }
}


-(DownloadProgressBLock)getDownloadProgressBlock{
    DownloadProgressBLock progressBlock = ^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead){
        if (totalBytesExpectedToRead > 0) {
            if ([[MPAudioPlayer sharedInstance] downloadOperationForSong:self.song]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.progressView.alpha = 1;
                    self.progressView.progress = (float)totalBytesRead / (float)totalBytesExpectedToRead;
                    NSLog(@"progress = %f",self.progressView.progress);
                    if (self.progressView.progress >= 1.){
                        self.song.isCached = YES;
                        [[AppDelegate appDelegate] saveContext];
                        [self fillWithSong:self.song];
                    }
                });
            }else{
                [self fillWithSong:self.song];
            }
        }
    };
    return progressBlock;
}

- (IBAction)downloadSong:(id)sender {
    self.downloadSongButton.hidden = YES;
    self.progressView.indeterminate = YES;
    [self.song downloadSongToHardWithDownloadBlock:[self getDownloadProgressBlock]];
    [self fillWithSong:self.song];
    NSLog(@"download %@",self.song.title);
}
@end
