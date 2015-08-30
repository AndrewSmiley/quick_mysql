//
//  FirstViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 9/11/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *commandTxt;
- (IBAction)onTouchDown:(id)sender;

@end
