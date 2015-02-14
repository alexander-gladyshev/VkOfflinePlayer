//
//  UserMO.h
//  VKOfflineMusicPlayer
//
//  Created by Alexander on 03/02/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SongMO;

@interface UserMO : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic) BOOL isOwner;
@property (nonatomic, retain) NSSet *songs;
@end

@interface UserMO (CoreDataGeneratedAccessors)

- (void)addSongsObject:(SongMO *)value;
- (void)removeSongsObject:(SongMO *)value;
- (void)addSongs:(NSSet *)values;
- (void)removeSongs:(NSSet *)values;

@end
