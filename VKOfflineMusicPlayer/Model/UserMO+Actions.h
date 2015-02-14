//
//  UserMO+Actions.h
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMO.h"

@interface UserMO (Actions)

+(UserMO *)getUserWithId:(NSString *)userId withContext:(NSManagedObjectContext *)context;

@end
