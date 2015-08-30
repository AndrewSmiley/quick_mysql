//
//  TablesListViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/20/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "TablesListViewController.h"
#import "ServerOverviewViewController.h"
#import "ViewTableDataViewController.h"
#import "TableOptionsViewController.h"
#import "NewMySQLTableViewController.h"
#import "UIAlertView+Blocks.h"
@interface TablesListViewController ()

@end

@implementation TablesListViewController
@synthesize connection, tableView, tables, server, schema;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"Tables on %@", schema]];
    self.clearsSelectionOnViewWillAppear = YES;
    [self reloadTableData:NO];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newButtonPressed)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    //    self.navigationItem.leftBarButtonItem = upButton;
    self.navigationItem.rightBarButtonItems= @[newButton, refreshButton];

        // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [tables count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [tables objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableOptionsViewController * tovc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableOptionsViewController"];
    [tovc setServer:server];
    [tovc setConnection:connection];
    [tovc setSchema:schema];
    [tovc setTableName: [tables objectAtIndex:indexPath.row]];
    [[self navigationController] pushViewController:tovc animated:YES];

//    ViewTableDataViewController *vtdvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewTableDataViewController"];
//    [vtdvc setConnection:connection];
//    [vtdvc setServer:server];
//    [vtdvc setTable:[tables objectAtIndex:indexPath.row]];
//    [vtdvc setSchema:schema];
//    [self.navigationController pushViewController:vtdvc animated:YES];
}

-(void) newButtonPressed{
    [UIAlertView showWithTitle:nil message:@"Enter a new table name: " style:UIAlertViewStylePlainTextInput cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Create"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex != 0) {
            NewMySQLTableViewController *mtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMySQLTableViewController"];
            [mtvc setConnection:connection];
            [mtvc setServer:server];
            [mtvc setSchema:schema];
            [mtvc setTableName:[[alertView textFieldAtIndex:0] text]];
            [self.navigationController pushViewController:mtvc animated:YES];
            
        }

    }];
}
-(void) refreshButtonPressed{
    [self reloadTableData:YES];
}

-(void) tableWasCreated{
    [self reloadTableData:YES];
}
-(void) reloadTableData: (BOOL) reloadTable{
    //let's make sure the connection to the db is still fresh
    
    if (mysql_ping(&connection)) {
        //if not lets
        ServerOverviewViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerOverviewViewController"];
        [sovc setServer:server];
        [[self navigationController] popToRootViewControllerAnimated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection to database has been lost." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];


    }else{
        char *db = [schema UTF8String];
        int result = mysql_select_db(&connection, db);
        if (result != 0) {
            ServerOverviewViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerOverviewViewController"];
            [self presentViewController:sovc animated:YES completion:^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error code %u: %s", mysql_errno(&connection), mysql_error(&connection)] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }];
            
        }else{
            NSString *sql = @"SHOW TABLES;";
            int status = mysql_real_query(&connection, [sql UTF8String], [sql length]);
            if (status == 0){
                MYSQL_RES *result = mysql_store_result(&connection);
                if (result != NULL) {
                    MYSQL_ROW row;
                    tables = [[NSMutableArray alloc] init];
                    while ((row = mysql_fetch_row(result))) {
                        char *charData = row[0];
                        NSString *stringData = [[NSString alloc] initWithCString:charData encoding:NSUTF8StringEncoding];
                        [tables addObject:stringData];
                    }
                    
                }else{
                    NSLog(@"This Schema seems to have no tables ");
                }
            }else{
                //not sure what to do here
                NSLog([NSString stringWithFormat:@"Error code %u: %s", mysql_errno(&connection), mysql_error(&connection)]);
            }
        }
        
        
    }

    if (reloadTable) {
        [self.tableView reloadData];
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
