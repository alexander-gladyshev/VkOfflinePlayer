//
//  MPAudioPlayer.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongMO+Actions.h"

typedef enum : NSUInteger {
    MPAudioPlayerStateStoped,
    MPAudioPlayerStatePlaying,
    MPAudioPlayerStatePaused,
} MPAudioPlayerState;


@interface MPAudioPlayer : NSObject

+(MPAudioPlayer *)sharedInstance;
-(void)playSong:(SongMO *)song;
-(void)play;
-(void)pause;
-(BOOL)isCurrentSong:(SongMO *)song;

@property (nonatomic) MPAudioPlayerState state;

@end
