//
//  NewServerViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 9/12/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
@interface NewServerViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UITextField *connectionNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *hostNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *portTxt;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIPickerView *osPicker;
@property (weak, nonatomic) IBOutlet UISwitch *savePasswordRadio;
@property (weak, nonatomic) IBOutlet UITextView *notesTxt;
@property (weak, nonatomic) IBOutlet UIButton *addServerBtn;
@property NSArray *serverOptions;
@property NSManagedObjectContext* managedObjectContext;
- (IBAction)addServerBtnOnClick:(id)sender;
@property bool editing;
@property Server *server;
@end
