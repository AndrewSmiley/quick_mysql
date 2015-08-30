//
//  ManageTableOptionsViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/15/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mysql.h"
#import "Server.h"
#import "MySQLTable.h"
@interface TableOptionsViewController : UITableViewController <UIAlertViewDelegate>
@property NSArray *options;
@property NSString *schema;
@property (nonatomic) MYSQL connection;
@property Server *server;
@property NSString *tableName;
@property MySQLTable *tableTool;
@end
