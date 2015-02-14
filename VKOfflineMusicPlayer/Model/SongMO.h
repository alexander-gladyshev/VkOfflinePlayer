//
//  SongMO.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserMO;

@interface SongMO : NSManagedObject

@property (nonatomic, retain) NSString * albumId;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * genre_id;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) UserMO * owner;
@property (nonatomic, retain) NSNumber * orderId;
@property (nonatomic) BOOL isCached;

@end
