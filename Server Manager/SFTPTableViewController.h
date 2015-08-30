//
//  SFTPTableViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/1/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <NMSSH/NMSSH.h>
#import "SFTPHelper.h"
@interface SFTPTableViewController : UITableViewController
@property NSMutableArray *fileDirectoryList;
@property NMSSHSession *session;
@property Server *server;
@property SFTPHelper *sftpHelper;
-(void) backButtonPressed;
@end
