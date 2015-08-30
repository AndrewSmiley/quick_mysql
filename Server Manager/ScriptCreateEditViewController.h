//
//  ScriptCreateEditViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 12/29/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Script.h"
#import <CoreData/CoreData.h>
#import "ScriptDAO.h"
#import "Server.h"
#import <NMSSH/NMSSH.h>
@interface ScriptCreateEditViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *scriptNameTxt;
@property (weak, nonatomic) IBOutlet UITextView *scriptContentsTxt;
- (IBAction)onSaveBtnClick:(id)sender;
@property (weak, nonatomic) Script *script;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) ScriptDAO *scriptDAO;
@property NMSSHSession *session;
@property Server *server;
@end
