//
//  LinuxConsoleHistoryViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 4/12/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinuxConsoleHistoryViewController : UIViewController
@property NSMutableArray *commandHistory;
@property (weak, nonatomic) IBOutlet UITextView *commandHistoryTxt;
@end
