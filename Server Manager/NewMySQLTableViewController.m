//
//  NewMySQLTableViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/7/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "NewMySQLTableViewController.h"
#import "MySQLTable.h"
#import "UIAlertView+Blocks.h"
#import "EditSQLViewController.h"
@interface NewMySQLTableViewController ()

@end

@implementation NewMySQLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Table" style:UIBarButtonItemStyleBordered target:self action:@selector(createButtonPressed)];
    UIBarButtonItem *addColumnButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addColumnButtonPressed)];
    self.navigationItem.rightBarButtonItems = @[addColumnButton, createButton];
    _columns = [[NSMutableArray alloc] init];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
//    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    //    self.navigationItem.leftBarButtonItem = upButton;
//    self.navigationItem.rightBarButtonItems= @[newButton, refreshButton];
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
    return [_columns count];
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewMySQLColumnViewController *nmcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMySQLColumnViewController"];
    [nmcvc setDelegate:self];
    [nmcvc setColumn:[_columns objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:nmcvc animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewColumnCell" forIndexPath:indexPath];
    // Configure the cell...
    [cell.textLabel setText:[[_columns objectAtIndex:indexPath.row] columnName]];
    
    return cell;
}

-(void) columnWasCreated:(MySQLTableColumn *)column : (BOOL) backButtonPressed : (BOOL) isEditing{
    if (column != nil && !backButtonPressed && !isEditing) {
        [_columns addObject:column];
        [self.tableView reloadData];
    }else if (column != nil && isEditing){
        [self.tableView reloadData];
    }
    else{
        NSLog(@"We just hit the back button....");
    }
}

-(void) addColumnButtonPressed{
    NewMySQLColumnViewController *nmcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewMySQLColumnViewController"];
    [nmcvc setDelegate:self];
    [self.navigationController pushViewController:nmcvc animated:YES];
}

-(void) createButtonPressed{
    /*
     Here's where we're going to generate the SQL to allow us to 
     create the new table and all that bullshit
     */
    NSLog(@"Here's some SQL");
//    MySQLTable *tableHelper = [[MySQLTable alloc] init];
    __block MySQLTable *tableHelper = [[MySQLTable alloc] initWithConnectionAndServerAndSchema:_connection :_server :_schema];
    __block BOOL pop;
    __block NSString *sql = [tableHelper generateCreateTableSQL:_columns :_tableName :_schema];
    NSLog(sql);
    [UIAlertView showWithTitle:@"Alert" message:[NSString stringWithFormat:@"The following SQL is about to be executed: \r\r%@",sql] cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"Execute", @"Edit"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        MySQLResult *result;
        switch (buttonIndex) {
            case 0:
                [UIAlertView showWithTitle:@"Alert" message:@"Operation Cancelled" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
                break;
            case 1:
                //execute the SQL
                result = [tableHelper executeSQL:sql];
                //handle the result appropriately
                if ([result success]) {
                    [UIAlertView showWithTitle:@"Alert" message:[result error] cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        //if it was successful, we'll pop the view controller, pass it back to the tablelist and reload
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    
                }else{
                    //otherwise let them know
                    [UIAlertView showWithTitle:@"Alert" message:[result error] cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        
                    }];
                }
                break;

            case 2:
                [self reviewSQL: sql];
                break;
                
            default:
                break;
        }
        
    }];
    
}
-(void) viewDidDisappear:(BOOL)animated{
    [_delegate tableWasCreated];
    
}

-(void) reviewSQL: (NSString *) sql{
    //
    EditSQLViewController *esvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditSQLViewController"];
    [esvc setServer:_server];
    [esvc setConnection:_connection];
    [esvc setSql:sql];
    [self.navigationController pushViewController:esvc animated:YES];
}

                // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_columns removeObjectAtIndex:indexPath.row];
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
