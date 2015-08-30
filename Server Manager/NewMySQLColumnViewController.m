//
//  NewMySQLColumnViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/6/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "NewMySQLColumnViewController.h"
@interface NewMySQLColumnViewController (){
    NSMutableArray *dataTypes;
    BOOL datatypeNumeric;
    BOOL backButtonPressed;
    BOOL dataTypeDecimal;
    BOOL isEditing;
}
@end

@implementation NewMySQLColumnViewController
@synthesize delegate;
- (void)viewDidLoad {
    datatypeNumeric = false;
    backButtonPressed = false;
    dataTypeDecimal = false;
    isEditing = false;
    [_decimalPrecisionTxt setEnabled:NO];
    [_decimalScaleTxt setEnabled:NO];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //get all the subviews in view
    NSArray * subViews =[_scrollView subviews];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 1338)];
    NSLog([NSString stringWithFormat:@"height: %f", self.view.frame.size.height]);
    NSLog([NSString stringWithFormat:@"width: %f", self.view.frame.size.width]);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(navigateBackPressed)];
    self.navigationItem.leftBarButtonItems = @[backButton];
    [_primaryKeySwitch addTarget:self action:@selector(primaryKeySwitchListener:) forControlEvents:UIControlEventValueChanged];
    [_scrollView setContentSize:self.view.frame.size];

    //if the subview is a UITextField, set the delegate to self
    for (int i = 0; i < subViews.count; i++) {
        if ([subViews[i] isMemberOfClass:[UITextField class]]) {
            [subViews[i] setDelegate:self];
        }
    }
    //set picker stuff
    [_dataTypePicker setDelegate:self];
    [_dataTypePicker setDataSource:self];
    //basically, if we're editing a column we don't want to buffer with an empty string
    if (_column != nil) {
        dataTypes=[NSMutableArray arrayWithObjects:@"CHAR",@"VARCHAR",@"INT",@"SMALLINT", @"TINYINT",@"MEDIUMINT", @"BIGINT",@"FLOAT",@"DOUBLE",@"DECIMAL",@"DATE",@"DATETIME",@"TIMESTAMP",@"TIME",@"YEAR", @"BLOB", @"TINYBLOB", @"MEDIUMBLOB",@"LONGBLOB", nil];

    }else{
    dataTypes=[NSMutableArray arrayWithObjects:@"",@"CHAR",@"VARCHAR",@"INT",@"SMALLINT", @"TINYINT",@"MEDIUMINT", @"BIGINT",@"FLOAT",@"DOUBLE",@"DECIMAL",@"DATE",@"DATETIME",@"TIMESTAMP",@"TIME",@"YEAR", @"BLOB", @"TINYBLOB", @"MEDIUMBLOB",@"LONGBLOB", nil];
    }
    
    //if we're editing a column, we want to set the switches and the columns
    if (_column != nil) {
        isEditing=true;
        [_actionButton setTitle:@"Update" forState:UIControlStateNormal];
//        [_actionButton setTitle:@"Update" forState:UIControlState];
        
        // //ok so out of frustration here's what we're going to do
        //just set all the form components based upon data type first
        //then we'll go and change everything based upon the custom changes by the user
        if ([[_column dataType] isEqualToString:@"INT"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:YES];
            [_autoIncrementSwitch setEnabled:YES];
            [_zeroFillSwitch setOn:YES];
            [_zeroFillSwitch setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            datatypeNumeric = true;
            dataTypeDecimal = false;

        }
        if ([[_column dataType] isEqualToString:@"SMALLINT"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:YES];
            [_autoIncrementSwitch setEnabled:YES];
            [_zeroFillSwitch setOn:YES];
            [_zeroFillSwitch setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            datatypeNumeric = true;
            dataTypeDecimal = false;
        }
         if ([[_column dataType] isEqualToString:@"MEDIUMINT"]) {
             [_columnLengthTxt setEnabled:false];
             [_defaultTxt setEnabled:YES];
             [_binarySwitch setOn:NO];
             [_binarySwitch setEnabled:NO];
             [_autoIncrementSwitch setOn:YES];
             [_autoIncrementSwitch setEnabled:YES];
             [_zeroFillSwitch setOn:YES];
             [_zeroFillSwitch setEnabled:YES];
             [_binarySwitch setOn:NO];
             [_binarySwitch setEnabled:NO];
             datatypeNumeric = true;
             dataTypeDecimal = false;

         }
         if ([[_column dataType] isEqualToString:@"BIGINT"]) {
             [_columnLengthTxt setEnabled:false];
             [_defaultTxt setEnabled:YES];
             [_binarySwitch setOn:NO];
             [_binarySwitch setEnabled:NO];
             [_autoIncrementSwitch setOn:YES];
             [_autoIncrementSwitch setEnabled:YES];
             [_zeroFillSwitch setOn:YES];
             [_zeroFillSwitch setEnabled:YES];
             [_binarySwitch setOn:NO];
             [_binarySwitch setEnabled:NO];
             datatypeNumeric = true;
             dataTypeDecimal = false;

         }
        if ([[_column dataType] isEqualToString:@"FLOAT"]) {
            [_columnLengthTxt setEnabled:YES];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:YES];
            [_autoIncrementSwitch setEnabled:YES];
            [_zeroFillSwitch setOn:YES];
            [_zeroFillSwitch setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            datatypeNumeric = true;
            dataTypeDecimal = false;
        }
        if ([[_column dataType] isEqualToString:@"DOUBLE"]) {
            [_columnLengthTxt setEnabled:YES];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:YES];
            [_autoIncrementSwitch setEnabled:YES];
            [_zeroFillSwitch setOn:YES];
            [_zeroFillSwitch setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            datatypeNumeric = true;
            dataTypeDecimal = false;

        }
        if ([[_column dataType] isEqualToString:@"DECIMAL"]) {
            //        [_columnLengthTxt setEnabled:YES];
            [_decimalPrecisionTxt setEnabled:YES];
            [_decimalScaleTxt setEnabled:YES];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:YES];
            [_zeroFillSwitch setEnabled:YES];
            [_binarySwitch setOn:NO];
            //        [_binarySwitch setEnabled:NO];
            [_columnLengthTxt setEnabled:NO];
            //        datatypeNumeric = true;
            dataTypeDecimal = true;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"DATE"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"DATETIME"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"TIMESTAMP"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"TIME"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"YEAR"]) {
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"BLOB"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            dataTypeDecimal = false;
            datatypeNumeric = false;


        }
        if ([[_column dataType] isEqualToString:@"TINYBLOB"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            dataTypeDecimal = false;
            datatypeNumeric = false;
        }
        if ([[_column dataType] isEqualToString:@"MEDIUMBLOB"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"LONGBLOB"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"ENUM"]) {
            [_columnLengthTxt setEnabled:false];
            [_defaultTxt setEnabled:false];
            [_binarySwitch setOn:NO];
            [_binarySwitch setEnabled:NO];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            dataTypeDecimal = false;
            datatypeNumeric = false;
        }
        if ([[_column dataType] isEqualToString:@"CHAR"]) {
            [_columnLengthTxt setEnabled:YES];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        if ([[_column dataType] isEqualToString:@"VARCHAR"]) {
            [_columnLengthTxt setEnabled:YES];
            [_defaultTxt setEnabled:YES];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            [_autoIncrementSwitch setOn:NO];
            [_autoIncrementSwitch setEnabled:NO];
            [_zeroFillSwitch setOn:NO];
            [_zeroFillSwitch setEnabled:NO];
            [_binarySwitch setOn:YES];
            [_binarySwitch setEnabled:YES];
            dataTypeDecimal = false;
            datatypeNumeric = false;

        }
        
        
        [_columnNameTxt setText:[_column columnName]];
        if ([_column isPrimaryKey]) {
            [_defaultTxt setEnabled:NO];
            [_decimalPrecisionTxt setEnabled:[_column isDecimal]];
            [_decimalScaleTxt setEnabled:[_column isDecimal]];
//            [_decimalTxt setEnabled:NO];
//            [_columnLengthTxt setEnabled:[_column isNumeric]];
            
        }
        [_primaryKeySwitch setOn:[_column isPrimaryKey]];
        [_primaryKeySwitch setEnabled:[_column isPrimaryKey]];
        [_uniqueSwtich setOn:[_column isUnique]];
        [_uniqueSwtich setEnabled:[_column isUnique]];
        [_autoIncrementSwitch setOn:[_column isAutoIncrement]];
        [_autoIncrementSwitch setEnabled:[_column isAutoIncrement]];
        [_notNullSwitch setOn:[_column isNotNull]];
        [_notNullSwitch setEnabled:[_column isNotNull]];
        [_zeroFillSwitch setOn:[_column isZeroFill]];
        [_zeroFillSwitch setEnabled:[_column isZeroFill]];
        [_binarySwitch setOn:[_column isBinary]];
        [_binarySwitch setEnabled:[_column isBinary]];
        [_dataTypePicker selectRow:[dataTypes indexOfObject:[_column dataType]] inComponent:0 animated:YES];
        if ([_column isDecimal]) {
            [_decimalPrecisionTxt setText:[_column decimalPrecision]];
            [_decimalScaleTxt setText:[_column decimalScale]];
        }

        if ([_column length] != nil) {
            [_columnLengthTxt setText:[_column length]];
        }
        if ([_column defaultValue] != nil) {
            [_defaultTxt setText:[_column defaultValue]];
        }
        
        [[_column columnModifiers] removeAllObjects];
    }

    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

}

-(void) viewDidAppear:(BOOL)animated{
    //we only want to do this if the column is editing
    if (_column == nil) {
        [_primaryKeySwitch setOn:NO animated:YES];
    }
        
   }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataTypes count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataTypes objectAtIndex:row];
    
}

/**
 Detect changes in pickerview
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if ([[dataTypes objectAtIndex:[_dataTypePicker selectedRowInComponent:0]] isEqualToString:@""]) {
        [dataTypes removeObjectAtIndex:0];
        [_dataTypePicker reloadAllComponents];
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"INT"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:YES];
        [_autoIncrementSwitch setEnabled:YES];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        datatypeNumeric = true;
        dataTypeDecimal = false;
        
    }
    
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"SMALLINT"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:YES];
        [_autoIncrementSwitch setEnabled:YES];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        datatypeNumeric = true;
                dataTypeDecimal = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"MEDIUMINT"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:YES];
        [_autoIncrementSwitch setEnabled:YES];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        datatypeNumeric = true;
                dataTypeDecimal = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"BIGINT"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:YES];
        [_autoIncrementSwitch setEnabled:YES];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        datatypeNumeric = true;
                dataTypeDecimal = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"FLOAT"]) {
        [_columnLengthTxt setEnabled:YES];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:YES];
        [_autoIncrementSwitch setEnabled:YES];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        datatypeNumeric = true;
                dataTypeDecimal = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"DOUBLE"]) {
        [_columnLengthTxt setEnabled:YES];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:YES];
        [_autoIncrementSwitch setEnabled:YES];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        datatypeNumeric = true;
                dataTypeDecimal = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"DECIMAL"]) {
//        [_columnLengthTxt setEnabled:YES];
        [_decimalPrecisionTxt setEnabled:YES];
        [_decimalScaleTxt setEnabled:YES];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:YES];
        [_zeroFillSwitch setEnabled:YES];
        [_binarySwitch setOn:NO];
//        [_binarySwitch setEnabled:NO];
        [_columnLengthTxt setEnabled:NO];
//        datatypeNumeric = true;
        dataTypeDecimal = true;
        datatypeNumeric = false;
        
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"DATE"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"DATETIME"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"TIMESTAMP"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"TIME"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"YEAR"]) {
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"CHAR"]) {
        [_columnLengthTxt setEnabled:YES];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"VARCHAR"]) {
        [_columnLengthTxt setEnabled:YES];
        [_defaultTxt setEnabled:YES];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"BLOB"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"TINYBLOB"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        dataTypeDecimal = false;
        datatypeNumeric = false;
        
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"MEDIUMBLOB"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }
    if ([[dataTypes objectAtIndex:row] isEqualToString:@"LONGBLOB"]) {
        [_columnLengthTxt setEnabled:false];
        [_defaultTxt setEnabled:false];
        [_binarySwitch setOn:NO];
        [_binarySwitch setEnabled:NO];
        [_autoIncrementSwitch setOn:NO];
        [_autoIncrementSwitch setEnabled:NO];
        [_zeroFillSwitch setOn:NO];
        [_zeroFillSwitch setEnabled:NO];
        [_binarySwitch setOn:YES];
        [_binarySwitch setEnabled:YES];
        dataTypeDecimal = false;
        datatypeNumeric = false;
    }

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addColumnOnClick:(id)sender {
    if (_column != nil) {
        [_column setColumnName:[_columnNameTxt text]];
    }
    if ([[dataTypes objectAtIndex:[_dataTypePicker selectedRowInComponent:0]] isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You must select a data type before you can add a column." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //make sure we're not adding a new column when we're actually editing
        _column = (_column == nil) ? [[MySQLTableColumn alloc] initWithDataTypeAndLengthAndName:[dataTypes objectAtIndex:[_dataTypePicker selectedRowInComponent:0]] :[_columnNameTxt text]] : _column;
        
        [_column setIsNumeric:datatypeNumeric];
    //just set the default value, the decimal and the length if need be
    if ([_columnLengthTxt isEnabled]) {
        [_column setLength:[_columnLengthTxt text]];
    }
        [_column setIsNumeric:datatypeNumeric];
        [_column setIsDecimal:dataTypeDecimal];
        
        if (dataTypeDecimal) {
            
            [_column setDecimalPrecision:([[_decimalPrecisionTxt text] isEqualToString:@""] || [_decimalPrecisionTxt text] == nil) ? nil:[_decimalPrecisionTxt text]];
            [_column setDecimalScale:([[_decimalScaleTxt text] isEqualToString:@""] || [_decimalScaleTxt text] == nil) ? nil:[_decimalScaleTxt text]];
        }
            if ([_defaultTxt isEnabled] && ![[_defaultTxt text] isEqualToString:@""]) {
        [_column setDefaultValue:[_defaultTxt text]];
    }
    
    
    // so this part is going to be a BITCH
    /*
    @property (weak, nonatomic) IBOutlet UISwitch *primaryKeySwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *indexSwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *uniqueSwtich;
    @property (weak, nonatomic) IBOutlet UISwitch *autoIncrementSwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *nullSwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *notNullSwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *defaultSwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *zeroFillSwitch;
    @property (weak, nonatomic) IBOutlet UISwitch *binarySwitch;
    @property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
    */
    if ([_primaryKeySwitch isOn]) {
        [_column setIsPrimaryKey:YES];
//        [[_column columnModifiers] addObject:@"PRIMARY KEY"];
    }else{
        [_column setIsPrimaryKey:NO];
    }
//    if ([_indexSwitch isOn]) {
//        [[_column columnModifiers] addObject:@"INDEX"];
//    }
    if ([_uniqueSwtich isOn]) {
        [_column setIsUnique:YES];
    }else{
        [_column setIsUnique:NO];
    }

    if ([_zeroFillSwitch isOn]) {
        [[_column columnModifiers] addObject:@"ZEROFILL"];
        [_column setIsZeroFill:YES];
    }else{
        [_column setIsZeroFill:NO];
    }
    
    if ([_binarySwitch isOn]) {
        [[_column columnModifiers] addObject:@"BINARY"];
        [_column setIsBinary:YES];
    }else{
        [_column setIsBinary:NO];
    }
    
    if ([_notNullSwitch isOn]) {
        [[_column columnModifiers] addObject:@"NOT NULL"];
        [_column setIsNotNull:YES];
    }else{
        [[_column columnModifiers] addObject:@"NULL"];
        [_column setIsNotNull:NO];
    }

    if ([_autoIncrementSwitch isOn]) {
        [[_column columnModifiers] addObject:@"AUTO_INCREMENT"];
        [_column setIsAutoIncrement:YES];
    }else{
        [_column setIsAutoIncrement:NO];
    }

    /*
     I THINK default values come last.... I THINK
     */

    if ([_defaultTxt isEnabled] && !([[_defaultTxt text] isEqualToString:@""] || [[_defaultTxt text] isEqualToString:nil])) {
        //here's some niggary
        [[_column columnModifiers] addObject:[NSString stringWithFormat:@"DEFAULT %@", (datatypeNumeric || dataTypeDecimal) ?  [NSString stringWithFormat:@"%@", [_defaultTxt text]]:[NSString stringWithFormat:@"'%@'", [_defaultTxt text]] ]];
    }

    
    
    //ok so now that were here...
    [self.navigationController popViewControllerAnimated:YES];
    //but will it call the delegate...
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{

//    [delegate columnWasCreated:_column, backButtonPressed];
    [delegate columnWasCreated:_column :backButtonPressed : isEditing];
    
}

-(void) navigateBackPressed{
    backButtonPressed=true;
    [self.navigationController popViewControllerAnimated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [_columnLengthTxt resignFirstResponder];
    [_columnNameTxt resignFirstResponder];
    [_defaultTxt resignFirstResponder];
    [_decimalPrecisionTxt resignFirstResponder];
    [_decimalScaleTxt resignFirstResponder];
    return YES;
}

-(void) dismissKeyboard{
    [_columnLengthTxt resignFirstResponder];
    [_columnNameTxt resignFirstResponder];
    [_defaultTxt resignFirstResponder];
    [_decimalPrecisionTxt resignFirstResponder];
    [_decimalScaleTxt resignFirstResponder];
}

- (void)primaryKeySwitchListener:(id)sender{
    if([sender isOn]){
        [_defaultTxt setEnabled:NO];
    } else{
        [_defaultTxt setEnabled:YES];
    }
}

@end
