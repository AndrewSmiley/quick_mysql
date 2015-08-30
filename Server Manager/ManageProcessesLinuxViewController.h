//
//  ManageProcessesLinuxViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/6/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "Server.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface ManageProcessesLinuxViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NMSSHSession * session;
@property NSString * tempPassword;
@property Server * server;
@property MBProgressHUD *hud;
@end

