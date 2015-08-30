//
//  ViewSchemasViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/13/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mysql.h"
#import "Server.h"
@interface SchemasListViewController : UITableViewController
@property (nonatomic) MYSQL connection;
@property Server *server;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *schemas;
@property int flag;

@end
