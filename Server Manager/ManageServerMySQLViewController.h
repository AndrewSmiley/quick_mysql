//
//  ManageServerMySQLViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/13/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <NMSSH/NMSSH.h>
//#import "mysql.h"
@interface ManageServerMySQLViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property Server *server;
//@property MYSQL *connection;
@property NSString *tmpPassword;
@property NSMutableArray *options;
@end
