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

const float downloadMode = 7;
const float cachedMode = -50;
@interface MPSongViewCell ()

@property (nonatomic, strong) SongMO * song;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (nonatomic, strong) IBOutlet UCZProgressView * progressView;

@end

@implementation MPSongViewCell


-(void)prepareForReuse{
    if (self.song){
        AFHTTPRequestOperation * operation = [[MPAudioPlayer sharedInstance] downloadOperationForSong:self.song];
        if (operation){
            [operation setDownloadProgressBlock:nil];
        }
    }
}

-(void)fillWithSong:(SongMO *)song{
    self.song = song;
    self.songTitleLabel.text = [song fullName];
    self.durationLabel.text = [NSString stringWithFormat:@"%@",song.duration];
    [self.progressView setNeedsLayout];
    self.rightConstraint.constant = [song isCached] ? cachedMode : downloadMode;
    [self.progressView layoutIfNeeded];
    
    AFHTTPRequestOperation * operation = [[MPAudioPlayer sharedInstance] downloadOperationForSong:self.song];
    self.downloadSongButton.hidden = [song isCached] || operation;
    self.progressView.indeterminate = ![song isCached] && operation;
    if (operation){
        [operation setDownloadProgressBlock:[self getDownloadProgressBlock]];
    }
    NSLog(@"%@  --- %@", [song isCached] ? @"YES" : @"NO",song.title);
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
