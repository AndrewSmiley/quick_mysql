//
//  ManageServerLinuxViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/5/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <NMSSH/NMSSH.h>
@interface ManageServerLinuxViewController : UIViewController
- (IBAction)rebootOnClick:(id)sender;
- (IBAction)pingOnClick:(id)sender;
- (IBAction)installSoftwareOnClick:(id)sender;
- (IBAction)servicesOnClick:(id)sender;
- (IBAction)openConsoleOnClick:(id)sender;
- (IBAction)openScriptingOnClick:(id)sender;
@property Server *server;
@property NSString *tempPassword;
@property  NMSSHSession *session;
@end
