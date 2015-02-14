//
//  MPAudioPlayer.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongMO+Actions.h"
#import <AFNetworking.h>

typedef enum : NSUInteger {
    MPAudioPlayerStateStoped,
    MPAudioPlayerStatePlaying,
    MPAudioPlayerStatePaused,
} MPAudioPlayerState;

static NSMutableDictionary * downloadOperations;

@interface MPAudioPlayer : NSObject

+(MPAudioPlayer *)sharedInstance;
-(void)playSong:(SongMO *)song;
-(void)play;
-(void)pause;
-(BOOL)isCurrentSong:(SongMO *)song;

@property (nonatomic) MPAudioPlayerState state;

-(AFHTTPRequestOperation *)downloadOperationForSong:(SongMO *)song;

-(void)addDownloadOperation:(AFHTTPRequestOperation *)operation forSong:(SongMO *)song;

@end