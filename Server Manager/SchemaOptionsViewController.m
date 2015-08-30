//
//  SchemaOptionsViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/22/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SchemaOptionsViewController.h"
#import "UIAlertView+Blocks.h"
#import "SchemasListViewController.h"
#import "TablesListViewController.h"
@interface SchemaOptionsViewController ()

@end

@implementation SchemaOptionsViewController
@synthesize connection, server, schema;
- (void)viewDidLoad {
    [super viewDidLoad];
    _options = [[NSArray alloc] initWithObjects:@"Delete Schema", @"View Data", nil];
    _schemaTool = [[MySQLSchema alloc] initWithConnectionAndServerAndSchema: connection :server :schema];
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
    return [_options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchemaOptionCell" forIndexPath:indexPath];
    [cell.textLabel setText:[_options objectAtIndex:indexPath.row]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //delete schema
        
        [UIAlertView showWithTitle:@"Alert" message:@"Are you sure you wish to delete this schema?" cancelButtonTitle:@"No" otherButtonTitles:[[NSArray alloc] initWithObjects:@"Ok", nil] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            MySQLResult * result;
            switch (buttonIndex) {
                    //we canceled
                case 0:
                    break;
                    //so we want to delete
                case 1:
                    result = [_schemaTool dropSchema];
                    if ([result success]) {
                        [UIAlertView showWithTitle:@"Alert" message:[[NSString alloc] initWithFormat:@"Schema %@ successfully", schema] cancelButtonTitle:nil otherButtonTitles:[[NSArray alloc] initWithObjects:@"Ok", nil] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//                            TablesListViewController * tlvc = [[[self navigationController] viewControllers] objectAtIndex:4];
                            SchemasListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SchemasListViewController"];
                            [slvc setConnection:connection];
                            [slvc setServer:server];
                            [slvc setFlag:1];
                            [self.navigationController pushViewController:slvc animated:YES];
//                            //not sure if this one will work or not...
//                            [tlvc.tableView reloadData];
//                            [tlvc setConnection: connection];
//                            [tlvc setServer:server];
//                            [tlvc setSchema:schema];
//                            [tlvc reloadTableData: true];
//                            [self.navigationController popToViewController:tlvc animated:YES];
                            
                        }];
                    }
                    break;
                default:
                    break;
            }
            
        }];

    }else if (indexPath.row == 1){
        //basically if they select this option we want to take them to the table list
        
//    [UIAlertView showWithTitle:@"Alert" message:@"This functionality has not been implemented yet" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        NSLog(@"Nothing happened");
//    }];
    }else if (indexPath.row ==2){
        [UIAlertView showWithTitle:@"Alert" message:@"This functionality has not been implemented yet" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSLog(@"Nothing happened");
        }];
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
