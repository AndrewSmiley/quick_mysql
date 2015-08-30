//
//  MySQL.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/20/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"
#import "mysql.h"
@interface NSMySQL : NSObject
@property NSString *schema;
@property (nonatomic) MYSQL connection;
@property Server *server;
-(id) initWithConnection: (MYSQL) connection;
-(id) initWithConnectionAndServer:(MYSQL)connection: (Server *) server;
-(id) initWithConnectionAndServerAndSchema:(MYSQL)connection: (Server *) server: (NSString *) schema;

@end
