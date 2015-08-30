//
//  ViewSystemUsageViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/28/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <NMSSH/NMSSH.h>
@interface ViewSystemUsageViewController : UIViewController
- (IBAction)onRAMUsageClicked:(id)sender;
- (IBAction)onCPUUsageClicked:(id)sender;
- (IBAction)onDiskUsageClicked:(id)sender;
@property Server *server;
@property NSString *tempPassword;
@property  NMSSHSession *session;
@end
