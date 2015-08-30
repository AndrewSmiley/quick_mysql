//
//  ScriptingOptionsViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 12/29/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import "Server.h"
#import <NMSSH/NMSSH.h>
#import <CoreData/CoreData.h>
@interface ScriptOptionsViewController : UITableViewController
@property Script *script;
@property NSManagedObjectContext *managedObjectContext;
@property NSMutableArray *options;
@property NMSSHSession *session;
@property Server *server;
@end
