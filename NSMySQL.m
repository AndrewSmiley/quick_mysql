//
//  MySQL.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/20/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "NSMySQL.h"

@implementation NSMySQL
@synthesize connection, server, schema;

-(id) init{
    return self;
}

-(id) initWithConnection:(MYSQL)connection{
    [self setConnection:connection];
    return self;
}

-(id) initWithConnectionAndServer:(MYSQL)connection :(Server *)server{
    [self setConnection:connection];
    [self setServer:server];
    return self;
}

-(id) initWithConnectionAndServerAndSchema:(MYSQL)connection :(Server *)server :(NSString *)schema{
    [self setConnection:connection];
    [self setServer:server];
    [self setSchema:schema];
    return self;
}

-(BOOL) isConnected{
    return (mysql_ping(&connection) == 0);
}
@end
