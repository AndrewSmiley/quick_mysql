//
//  EditSQLViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 4/6/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
#import "mysql.h"
@interface EditSQLViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *sqlText;
@property (nonatomic) MYSQL connection;
@property Server *server;
@property NSString *sql;
- (IBAction)onExecuteSQLClicked:(id)sender;

@end
