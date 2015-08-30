//
//  SFTPFileViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/3/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTPFileHelper.h"
@interface SFTPFileViewController : UIViewController <UIAlertViewDelegate>
@property NSData *contents;
@property NSString *filename;
@property BOOL isCreating;
@property SFTPFileHelper *filehelper;
- (IBAction)onSaveFileClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *fileEditor;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@end
