//
//  NewMySQLColumnViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/6/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySQLTableColumn.h"
@protocol NewMySQLColumnViewControllerDelegate <NSObject>

-(void)columnWasCreated: (MySQLTableColumn *) column : (BOOL) backButtonPressed : (BOOL) editing;

@end

@interface NewMySQLColumnViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *columnNameTxt;
@property (weak, nonatomic) IBOutlet UIPickerView *dataTypePicker;
@property (weak, nonatomic) IBOutlet UITextField *columnLengthTxt;
@property (weak, nonatomic) IBOutlet UISwitch *primaryKeySwitch;
//@property (weak, nonatomic) IBOutlet UISwitch *indexSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *uniqueSwtich;
@property (weak, nonatomic) IBOutlet UISwitch *autoIncrementSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notNullSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *zeroFillSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *binarySwitch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *fieldOneLbl;
@property (weak, nonatomic) IBOutlet UITextField *decimalPrecisionTxt;
@property (weak, nonatomic) IBOutlet UITextField *decimalScaleTxt;
@property (weak, nonatomic) IBOutlet UITextField *defaultTxt;
@property(nonatomic,assign)id delegate;
@property MySQLTableColumn * column;
- (IBAction)addColumnOnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
