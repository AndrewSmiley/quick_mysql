//
//  ScriptingOptionsViewControllerTableViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "ScriptingOptionsViewControllerTableViewController.h"
#import "ScriptCreateEditViewController.h"
#import "ScriptListViewController.h"

@interface ScriptingOptionsViewControllerTableViewController ()

@end

@implementation ScriptingOptionsViewControllerTableViewController
@synthesize server, session;
- (void)viewDidLoad {
    [super viewDidLoad];
    _options = [[NSArray alloc] initWithObjects:@"Create New Script", @"View Script List", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScriptingOptionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_options objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert;
    ScriptCreateEditViewController *scevc;
    ScriptListViewController *slvc;
    switch (indexPath.row) {
            
        case 0:
            //why don't you work?
            scevc = [self.storyboard  instantiateViewControllerWithIdentifier:@"ScriptCreateEditViewController"];
            [scevc setSession:session];
            [scevc  setServer:server];
            [scevc setServer: server];
            [self.navigationController pushViewController:scevc animated:YES];
            break;
        case 1:
            slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
            [slvc setSession:session];
            [slvc setServer:server];
            [self.navigationController pushViewController:slvc animated:YES];
            break;
        default:
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error has occurred" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            break;
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
