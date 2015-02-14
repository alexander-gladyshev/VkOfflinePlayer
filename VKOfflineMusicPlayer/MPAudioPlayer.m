//
//  MPAudioPlayer.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MPAudioPlayer.h"
#import "SongMO+Actions.h"
#import <AVFoundation/AVFoundation.h>


static MPAudioPlayer * instance;


@interface MPAudioPlayer ()

@property (nonatomic, strong) AVPlayer * audioPlayer;
@property (nonatomic, strong) SongMO * currentSong;

@end


@implementation MPAudioPlayer

+(MPAudioPlayer *)sharedInstance{
    if (!instance){
        instance = [MPAudioPlayer new];
    }
    return instance;
}

-(void)pause{
    [self.audioPlayer pause];
    self.state = MPAudioPlayerStatePaused;
}
-(void)play{
    if (self.audioPlayer){
        [self.audioPlayer play];
        self.state = MPAudioPlayerStatePlaying;
    }
}

-(void)playSong:(SongMO *)song{
    if(self.audioPlayer){
        [self.audioPlayer pause];
        self.audioPlayer = nil;
    }
    
    self.audioPlayer = [[AVPlayer alloc] initWithURL:[song isCached] ? [[NSURL alloc ] initFileURLWithPath: [song fullPath]] : [NSURL URLWithString:song.url]];
    [self.audioPlayer play];
    self.currentSong = song;
    self.state = MPAudioPlayerStatePlaying;
}

-(BOOL)isCurrentSong:(SongMO *)song{
    if ([song.identifier isEqualToString:self.currentSong.identifier]){
        return YES;
    }
    return NO;
}


-(AFHTTPRequestOperation *)downloadOperationForSong:(SongMO *)song{
    return [downloadOperations objectForKey:song.identifier];
}

-(void)addDownloadOperation:(AFHTTPRequestOperation *)operation forSong:(SongMO *)song{
    if (!downloadOperations) downloadOperations = [NSMutableDictionary dictionary];
    [downloadOperations setObject:operation forKey:song.identifier];
}

@end
