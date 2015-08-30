//
//  MySQLTable.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/15/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "MySQLTable.h"
#import "mysql.h"
#import "MySQLTableColumn.h"
@implementation MySQLTable
@synthesize schema, connection, server;
-(MySQLResult *) deleteTable: (NSString *) tablename{
    NSString *sql = [[NSString alloc] initWithFormat:@"DROP TABLE %@", tablename];
    MySQLResult *mysqlResult;
    char *db = [schema UTF8String];
    int result = mysql_select_db(&connection, db);
    if (result != 0) {
        mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"%s",mysql_error(&connection)] :false];
    }else{
        int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
        if (status != 0) {
            mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"Error deleting table %@: %s", tablename, mysql_error(&connection)] :false];
        }else{
            mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"Table %@ deleted successfully", tablename] :true];
        }
    }
    return mysqlResult;
}

-(NSString *) generateCreateTableSQL:(NSMutableArray *) columns: (NSString *) tableName: (NSString *) schemaName{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE `%@`.`%@` (", schemaName, tableName];
    //ok, so sqlColumns here is the first part, i.e. the `test` INT UNSIGNED NOT NULL AUTO_INCREMENT , part of the code
    NSString *sqlColumns=@"";
    NSMutableArray *primaryKeys = [[NSMutableArray alloc] init];
    NSMutableArray *uniqueIdentifiers = [[NSMutableArray alloc] init];
//    NSString *primaryKeys = @"";
//    NSString *uniqueIdentifiers = @"";
//    for (MySQLTableColumn *column in columns) {
    for (int i = 0; i < [columns count]; i++) {
        MySQLTableColumn *column = [columns objectAtIndex:i];
        sqlColumns = [NSString stringWithFormat:@"%@ %@", sqlColumns, [NSString stringWithFormat:@"`%@` %@ %@", [column columnName], ([column isDecimal]) ? (([[column decimalPrecision] isEqualToString:@""] || [column decimalPrecision] == nil) || ([[column decimalScale] isEqualToString:@""] || [column decimalScale] == nil)) ?  [NSString stringWithFormat:@"%@", [column dataType]] : [NSString stringWithFormat:@"%@(%@,%@)", [column dataType] , [column decimalPrecision], [column decimalScale]] : [column dataType], ([column length] != nil) ? [NSString stringWithFormat:@"(%@)", [column length]] : @""]];
            for(NSString * modifier in [column columnModifiers]){
                sqlColumns = [NSString stringWithFormat:@"%@ %@", sqlColumns, modifier];
            }
        sqlColumns = [NSString stringWithFormat:@"%@ ,", sqlColumns];
        /*
         So here's kinda what I'm thinking-
         add all the instances of primary keys and unique keys so we can get the commas and shit right
         */
        if ([column isPrimaryKey]) {
            [primaryKeys addObject:[NSString stringWithFormat:@"PRIMARY KEY (`%@`) ", [column columnName]]];
        }
        
        if ([column isUnique]) {
            [uniqueIdentifiers addObject:[NSString stringWithFormat:@"UNIQUE INDEX `%@_UNIQUE` (`%@` ASC)",[column columnName], [column columnName]]];
        }
    }
    NSString *pkString = @"";
    NSString *uniqueString =@"";
    for (int i = 0; i < [primaryKeys count]; i++) {
        if (i == ([primaryKeys count] -1) && [uniqueIdentifiers count] <= 0) {
            pkString = [NSString stringWithFormat:@"%@ %@", pkString, [primaryKeys objectAtIndex:i]];
        }else if (i == ([primaryKeys count] -1) && [uniqueIdentifiers count] > 0){
            pkString = [NSString stringWithFormat:@"%@ %@,", pkString, [primaryKeys objectAtIndex:i]];
        }else{
            pkString = [NSString stringWithFormat:@"%@ %@,", pkString, [primaryKeys objectAtIndex:i]];
        }
    }
    
    for (int i = 0; i < [uniqueIdentifiers count]; i++) {
        if (i == ([uniqueIdentifiers count]-1)) {
            uniqueString = [NSString stringWithFormat:@"%@ %@", uniqueString, [uniqueIdentifiers objectAtIndex:i]];
        }else{
            uniqueString = [NSString stringWithFormat:@"%@ %@,", uniqueString, [uniqueIdentifiers objectAtIndex:i]];
        }
    }
    sql = [NSString stringWithFormat:@"%@ %@ %@ %@", sql, sqlColumns, pkString, uniqueString];
    //close that shit
    //lol
    sql = [NSString stringWithFormat:@"%@ );", sql];
    return sql;

}
-(MySQLResult *) executeSQL: (NSString *) sql{
//    NSString *sql = [[NSString alloc] initWithFormat:@"DROP SCHEMA %@", schema];
    
    MySQLResult *mysqlResult;
    char *db = [schema UTF8String];
    int result = mysql_select_db(&connection, db);
    if (result != 0) {
        mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"%s",mysql_error(&connection)] :false];
    }else{
        int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
        if (status != 0) {
            mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:[[NSString alloc] initWithFormat:@"Error executing SQL %@: %s", schema, mysql_error(&connection)] :false];
        }else{
            mysqlResult = [[MySQLResult alloc] initWithErrorAndSuccess:@"SQL executed successfully" :true];
        }
    }
    return mysqlResult;

    
    
}
@end
