//
//  MySQLRow.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/22/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//
/*
 Basically a wrapper class for storing MYSQL_ROW data as an object
 May try storing this as K,V pairs (NSDictionary maybe?)
 */
#import <Foundation/Foundation.h>

@interface NSMySQLRow : NSObject
@property NSMutableArray *fields;
-(void) addObject: (NSString *) data;
-(NSString *) objectAtIndex: (NSInteger *) index;
-(id) init;
@end
