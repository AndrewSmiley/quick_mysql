//
//  YumListInstalledViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "Server.h"
#import "MBProgressHud.h"
@interface YumListInstalledViewController : UITableViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NMSSHSession *session;
@property Server *server;
@property NSString *flags;
@property NSMutableArray * daSoftwares;
@property NSString *tempPassword;
-(void) updateTableData;
@property MBProgressHUD *hud;
@end
