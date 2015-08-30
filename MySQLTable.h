//
//  MySQLTable.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/15/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySQLResult.h"
#import "mysql.h"
#import "NSMySQL.h"
@interface MySQLTable : NSMySQL
-(MySQLResult *) deleteTable: (NSString *) tablename;

/*
 Function to generate SQL to create a table using a collection of MySQLColumn Objects
 */
-(NSString *) generateCreateTableSQL:(NSMutableArray *) columns: (NSString *) tableName: (NSString *) schema;
-(MySQLResult *) executeSQL: (NSString *) sql;
@end
