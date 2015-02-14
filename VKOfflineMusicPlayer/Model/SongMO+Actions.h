//
//  SongMO+Actions.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongMO.h"
#import "UserMO+Actions.h"

@interface SongMO (Actions)

+(void)parseSongsJSON:(NSDictionary *)json withContext:(NSManagedObjectContext *)context;

+(NSFetchedResultsController *)getFetchResultControllerWithAllSongs;

+(NSArray *)getSongsWithContext:(NSManagedObjectContext *)context;

-(NSString *)fullName;

-(NSString *)fullPath;

-(BOOL)isCached;

-(void)downloadSongToHard;

@end