//
//  SelectPackageManagerLinuxViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//
#import <NMSSH/NMSSH.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "Server.h"
@interface SelectPackageManagerLinuxViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *packageManagers;
@property Server *server;
@property NSString *tempPassword;
@property NMSSHSession *session;
@end
