//
//  TablesListViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/20/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mysql.h"
#import "Server.h"
#import "NewMySQLTableViewController.h"
@interface TablesListViewController : UITableViewController <NewMySQLTableViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSString *schema;
@property (nonatomic) MYSQL connection;
@property Server *server;
@property NSMutableArray *tables;
@property int *flags;
-(void) reloadTableData: (BOOL) reloadTable;
@end
