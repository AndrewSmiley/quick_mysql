//
//  ScriptRunViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 12/30/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import <NMSSH/NMSSH.h>
@interface ScriptRunViewController : UIViewController
@property NMSSHSession *session;
@property Server *server;
@end
