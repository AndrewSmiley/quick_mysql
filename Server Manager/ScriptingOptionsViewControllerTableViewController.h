//
//  ScriptingOptionsViewControllerTableViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <NMSSH/NMSSH.h>
@interface ScriptingOptionsViewControllerTableViewController : UITableViewController
@property NSArray *options;
@property NMSSHSession *session;
@property Server *server;
@end
