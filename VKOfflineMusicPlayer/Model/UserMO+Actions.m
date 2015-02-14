//
//  UserMO+Actions.m
//  VKOfflineMusicPlayer
//
//  Created by ALEXANDER GLADYSHEV on 26/01/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "UserMO+Actions.h"

@implementation UserMO (Actions)

+(UserMO *)getUserWithId:(NSString *)userId withContext:(NSManagedObjectContext *)context{
    NSFetchRequest * request = [NSFetchRequest new];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:@"UserMO" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"identifier = %@", userId];
    [request setPredicate:predicate];
    NSArray * result = [context executeFetchRequest:request error:nil];
    UserMO * user;
    if ([result count]){
        user = result[0];
    }else{
        user = (UserMO *)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        user.identifier = [NSString stringWithFormat:@"%@",userId];
        [context save:nil];
        
    }
    return user;
}

@end
