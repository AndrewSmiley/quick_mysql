//
//  AptGetInstallNewViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "Server.h"
#import "MBProgressHud.h"
@interface AptGetInstallNewViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NMSSHSession *session;
@property Server *server;
@property NSString *flags;
@property NSMutableArray * daSoftwares;
@property MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSString *tempPassword;
@end
