//
//  ServerDAO.h
//  Server Manager
//
//  Created by Andrew Smiley on 9/14/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Server.h"
@interface ServerDAO : NSObject
//add a new server to core data
-(void) addServer:(Server *) server: (NSManagedObjectContext *) managedObjectContext;
//get all the saved servers from core data
-(NSMutableArray *) getAllServers:(NSManagedObjectContext *) managedObjectContext;
//get a specific server by the server name
-(Server *) getServerByServerName:(NSString *) serverName:(NSManagedObjectContext *)managedObjectContext;
//get a server by the server ID
-(Server *) getServerByServerID:(NSInteger *) serverID:(NSManagedObjectContext *)managedObjectContext;
//-(id) initWithManagedObjectContext: (NSManagedObjectContext *) context;
-(BOOL) isPasswordSaved:(Server*) server;
-(BOOL) deleteServer: (Server *) server: (NSManagedObjectContext *) managedObjectContext;
@end
