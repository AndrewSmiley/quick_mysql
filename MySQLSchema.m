//
//  MySQLSchema.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/15/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "MySQLSchema.h"

@implementation MySQLSchema
@synthesize server, connection, schema;
-(MySQLResult *) dropSchema{
    NSString *sql = [[NSString alloc] initWithFormat:@"DROP SCHEMA %@", schema];
    MySQLResult *mysqlResult;
    char *db = [schema UTF8String];
    int result = mysql_select_db(&connection, db);
    if (result != 0) {
        mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"%s",mysql_error(&connection)] :false];
    }else{
        int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
        if (status != 0) {
            mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"Error dropping schema %@: %s", schema, mysql_error(&connection)] :false];
        }else{
            mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"Schema %@ deleted successfully", schema] :true];
        }
    }
    return mysqlResult;

}
@end
