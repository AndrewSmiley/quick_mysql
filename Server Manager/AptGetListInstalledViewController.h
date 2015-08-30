//
//  AptGetListInstalledViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//
#import <NMSSH/NMSSH.h>
#import "Server.h"
#import <UIKit/UIKit.h>
#import "MBProgressHud.h"
//dpkg --get-selections | grep -v deinstall
@interface AptGetListInstalledViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>
@property NMSSHSession *session;
@property Server *server;
@property NSString *flags;
@property NSMutableArray * daSoftwares;
@property NSString *tempPassword;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property MBProgressHUD *hud;
-(void) updateData;
@end
