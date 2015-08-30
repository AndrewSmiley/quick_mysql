//
//  SchemaOptionsViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/22/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mysql.h"
#import "Server.h"
#import "MySQLSchema.h"
@interface SchemaOptionsViewController : UITableViewController
@property NSArray *options;
@property NSString *schema;
@property (nonatomic) MYSQL connection;
@property Server *server;
@property NSString *tableName;
@property MySQLSchema *schemaTool;
@end
