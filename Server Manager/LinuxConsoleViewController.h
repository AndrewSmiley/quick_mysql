//
//  LinuxConsoleViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/6/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "Server.h"

@interface LinuxConsoleViewController : UIViewController <UITextFieldDelegate, NMSSHChannelDelegate>
@property NMSSHSession *session;
@property Server *server;
@property (weak, nonatomic) IBOutlet UITextField *commandTextField;
- (IBAction)onExecuteCommandClicked:(id)sender;
- (IBAction)onShowCommandHistoryClicked:(id)sender;

@end
