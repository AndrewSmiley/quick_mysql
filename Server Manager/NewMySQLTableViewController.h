//
//  NewMySQLTableViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/7/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mysql.h"
#import "Server.h"
#import "NewMySQLColumnViewController.h"
@protocol NewMySQLTableViewControllerDelegate <NSObject>
//basically so we can tell the view controller before this one to reload the table data
-(void)tableWasCreated;

@end
@interface NewMySQLTableViewController : UITableViewController <NewMySQLColumnViewControllerDelegate>
@property (nonatomic) MYSQL connection;
@property Server *server;
@property NSMutableArray *columns;
@property NSString *tableName;
@property NSString *schema;
@property(nonatomic,assign)id delegate;
@end
