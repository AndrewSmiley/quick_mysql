//
//  EditSQLViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 4/6/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "EditSQLViewController.h"
#import "SQLResultViewController.h"
@interface EditSQLViewController ()

@end

@implementation EditSQLViewController
@synthesize connection, server, sqlText;
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
//    UIBarButtonItem *dismissKeyboardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addColumnButtonPressed)];
    UIBarButtonItem *dismissKeyboardButton=[[UIBarButtonItem alloc] initWithTitle:@"Dismiss Keyboard" style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    self.navigationItem.rightBarButtonItems = @[dismissKeyboardButton];

    
    if (_sql != nil ) {
        NSLog([NSString stringWithFormat:@"SQL we want to set %@", _sql]);
        [sqlText setText:_sql];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onExecuteSQLClicked:(id)sender {
    NSString *sql = [sqlText text];
    if (sql == nil || [sql  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"SQL entered cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
        if (status != 0) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Could not execute SQL on %@ for reason  %u %s", [server serverName],             mysql_errno(&connection), mysql_error(&connection)] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            MYSQL_RES *result = mysql_store_result(&connection);
            if (result == NULL) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"SQL executed successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSLog(@"Guess it's working... ");
                MYSQL_ROW row;
                NSMutableArray *data = [[NSMutableArray alloc] init];
                while ((row = mysql_fetch_row(result))) {
                    NSMutableArray *dataRow = [[NSMutableArray alloc] init];
                    for (int i = 0; i < mysql_field_count(&connection); i++) {
                        [dataRow addObject:[NSString stringWithUTF8String:row[i]]];
                        
                        //                    NSLog([NSString stringWithFormat:@"%s", row[i]]);
                    }
                    [data addObject:dataRow];
                }
                
                MYSQL_FIELD *fields;
                int num = mysql_num_fields(result);
                NSMutableArray *fieldData = [[NSMutableArray alloc] init];
                SQLResultViewController *srvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SQLResultViewController"];
                
                if (num > 1) {
                    fields = mysql_fetch_fields(result);
                    for (int i = 0; i < num; i++ ) {
                        [fieldData addObject:[NSString stringWithUTF8String:fields[i].name]];
                    }
                    [srvc setFields:fieldData];
                }

                [srvc setData:data];
                [self.navigationController pushViewController:srvc animated:YES];
                
            }
        }
    }
}

-(void)dismissKeyboard {
    [sqlText resignFirstResponder];
}
@end
