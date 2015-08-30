//
//  ManageTableOptionsViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/15/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "TableOptionsViewController.h"
#import "UIAlertView+Blocks.h"
#import "MySQLResult.h"
#import "TablesListViewController.h"
#import "SQLResultViewController.h"
@interface TableOptionsViewController ()

@end

@implementation TableOptionsViewController
@synthesize server, schema, connection, tableName;
- (void)viewDidLoad {
    [super viewDidLoad];
    _options = [[NSArray alloc] initWithObjects:@"Delete Table", @"Alter Table", @"View Data", nil];
    _tableTool = [[MySQLTable alloc] initWithConnectionAndServerAndSchema:connection :server :schema];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableOptionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell.textLabel setText:[_options objectAtIndex:indexPath.row]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    @"Delete Table", @"Alter Table", @"View Data"
    NSString *deleteSQL = [[NSString alloc] initWithFormat:@"DROP TABLE %@", tableName];
    NSString *alterSQL = [[NSString alloc] initWithFormat:@"ALTER TABLE %@", tableName];
    if (indexPath.row == 0) {
        
        [UIAlertView showWithTitle:@"Alert" message:@"Are you sure you wish to delete this table?" cancelButtonTitle:@"No" otherButtonTitles:[[NSArray alloc] initWithObjects:@"Ok", nil] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            MySQLResult * result;
            switch (buttonIndex) {
                    //we canceled
                case 0:
                    break;
                    //so we want to delete
                case 1:
                    result = [_tableTool deleteTable:tableName];
                    if ([result success]) {
                        [UIAlertView showWithTitle:@"Alert" message:[[NSString alloc] initWithFormat:@"Deleted table %@ successfully", tableName] cancelButtonTitle:nil otherButtonTitles:[[NSArray alloc] initWithObjects:@"Ok", nil] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                            TablesListViewController * tlvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TablesListViewController"];
                            //not sure if this one will work or not...
                            [tlvc.tableView reloadData];
                            [tlvc setConnection: connection];
                            [tlvc setServer:server];
                            [tlvc setSchema:schema];
                            [tlvc reloadTableData: true];
                            [self.navigationController pushViewController:tlvc animated:YES];
//                            [self.navigationController popToViewController:tlvc animated:YES];
                            
                        }];
                    }
                    break;
                default:
                    break;
            }
            
        }];
        ///case we want to alter the table
    }else if (indexPath.row == 1){
        [UIAlertView showWithTitle:@"Alert" message:@"This functionality has not been implemented yet" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSLog(@"Nothing happened");
        }];
        //case we want to view the data
    }else if (indexPath.row == 2){
        [UIAlertView showWithTitle:@"Alert" message:@"This functionality has not been implemented yet" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSLog(@"Nothing happened");
        }];
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@.%@", schema, tableName];
        int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
        if (status != 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Could not execute SQL on %@ for reason  %u %s", [server serverName],             mysql_errno(&connection), mysql_error(&connection)] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            
        MYSQL_RES *result = mysql_store_result(&connection);
        if (result == NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Could not execute SQL on %@", [server serverName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
