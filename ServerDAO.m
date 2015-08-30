//
//  ServerDAO.m
//  Server Manager
//
//  Created by Andrew Smiley on 9/14/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ServerDAO.h"

@implementation ServerDAO
#pragma mark- Add a new server to CoreData
-(void) addServer:(Server *)server :(NSManagedObjectContext *)managedObjectContext{
    
}
#pragma mark- Get all the user saved servers from CoreData
-(NSMutableArray *) getAllServers:(NSManagedObjectContext *)managedObjectContext{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Server"];
    [fetchRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    //    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"truckID == %@", [truck truckID]]];
    //    NSLog([NSString stringWithFormat:@"%@", [truck truckID]]);
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([results count] > 0 & error == nil) {
        return [[NSMutableArray alloc] initWithArray:results];
    }else{
        return [[NSMutableArray alloc] init];
    }

}

#pragma mark- Get a server from CoreData by serverID
-(Server *) getServerByServerID:(NSInteger *)serverID:(NSManagedObjectContext *)managedObjectContext{
    return [[Server alloc] init];
}

#pragma mark- Get a server by its user saved name from CoreData
-(Server *) getServerByServerName:(NSString *)serverName:(NSManagedObjectContext *)managedObjectContext{
    return [[Server alloc] init];
}


-(BOOL) isPasswordSaved:(Server*) server{
    if ([[server password] length] == 0 || [server password] == nil) {
        return false;
    }else{
        return true;
    }
}

-(BOOL) deleteServer: (Server *) server: (NSManagedObjectContext *) managedObjectContext{
    [managedObjectContext deleteObject:server];
    NSError * err;
    [managedObjectContext save:&err];
    if (err != nil) {
        return false;
    }else{
        return true;
    }
    
    
}

@end
