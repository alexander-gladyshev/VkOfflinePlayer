//
//  SongMO+Actions.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "SongMO+Actions.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "MPAudioPlayer.h"
#import "MPSongViewCell.h"

@implementation SongMO (Actions)

+(SongMO *)getSongWithId:(NSString *)songId withContext:(NSManagedObjectContext *)context{
    NSFetchRequest * request = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"SongMO" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"identifier = %@", songId];
    [request setPredicate:predicate];
    NSArray * result = [context executeFetchRequest:request error:nil];
    SongMO * song;
    if ([result count]){
        song = result[0];
    }else{
        song = (SongMO *)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        song.identifier = [NSString stringWithFormat:@"%@", songId];
        [context save:nil];
        
    }
    return song;
}

+(void)parseSongsJSON:(NSDictionary *)json withContext:(NSManagedObjectContext *)context{
    NSArray * songs = json[@"items"];
    for (NSDictionary * songDic in songs) {
        SongMO * song = [SongMO getSongWithId:songDic[@"id"] withContext:context];
        song.artist = songDic[@"artist"];
        song.duration = songDic[@"duration"];
        song.genre_id = [NSString stringWithFormat:@"%@", songDic[@"genre_id"]];
        song.owner = [UserMO getUserWithId:songDic[@"owner_id"] withContext:context];
        song.title = songDic[@"title"];
        song.url = songDic[@"url"];
        song.orderId = @([songs indexOfObject:songDic]);
    }
    [context save:nil];
}

+(NSFetchedResultsController *)getFetchResultCOntrollerWithCachedSongs{
    NSFetchRequest * request = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"SongMO"
                                                          inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
    [request setEntity:entityDescription];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderId" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isCached==%@",@(YES)];
    [request setPredicate:predicate];
    
    NSFetchedResultsController * fetchResCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                    managedObjectContext:[AppDelegate appDelegate].managedObjectContext
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:nil];
    if (![fetchResCtrl performFetch:nil]){
        return nil;
    }
    return fetchResCtrl;
}

+(NSFetchedResultsController *)getFetchResultControllerWithAllSongs{
    NSFetchRequest * request = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"SongMO"
                                                          inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
    [request setEntity:entityDescription];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderId" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController * fetchResCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                    managedObjectContext:[AppDelegate appDelegate].managedObjectContext
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:nil];
    if (![fetchResCtrl performFetch:nil]){
        return nil;
    }
    return fetchResCtrl;
}

+(NSFetchedResultsController *)getFetchResultControllerWithSongsForOwnerId:(NSString *)ownerId{
    NSFetchRequest * request = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"SongMO"
                                                          inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
    [request setEntity:entityDescription];
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"orderId" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSManagedObject *newNumbers = [NSEntityDescription insertNewObjectForEntityForName:@"SongMO" inManagedObjectContext:[AppDelegate appDelegate].managedObjectContext];
                                   NSPredicate * predicate = [NSPredicate predicateWithFormat:@"owner.identifier = %@",ownerId];
    [request setPredicate:predicate];
    NSFetchedResultsController * fetchResCtrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                    managedObjectContext:[AppDelegate appDelegate].managedObjectContext
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:nil];
    if (![fetchResCtrl performFetch:nil]){
        return nil;
    }
    return fetchResCtrl;
}

-(NSString *)fullName{
    return [self.artist stringByAppendingFormat:@" - %@",self.title];
}

-(NSString *)fullPath{
    return [NSString stringWithFormat:@"%@%@.mp3",[NSHomeDirectory() stringByAppendingString:@"/Documents/"],[self.title stringByAppendingString:self.identifier]];
}

-(BOOL)isRealCached{
    return self.isCached && [[NSFileManager defaultManager] fileExistsAtPath:[self fullPath]];
}

-(void)downloadSongToHardWithDownloadBlock:(DownloadProgressBLock)downloadBlock{
    if ([self isCached]){
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:self.fullPath append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", self.fullPath);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation setDownloadProgressBlock:downloadBlock];
    [[MPAudioPlayer sharedInstance] addDownloadOperation:operation forSong:self];
    [operation start];
}

-(void)setIsCached:(BOOL)isCached{
    if ([[NSFileManager defaultManager]fileExistsAtPath:self.fullPath]){
        [self willChangeValueForKey:@"isCached"];
        [self setPrimitiveValue:@(isCached) forKey:@"isCached"];
        [self didChangeValueForKey:@"isCached"];
        
        NSLog(@"Cached : >>>>>> %@", self.fullName);
    }
}

@end
