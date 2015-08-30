//
//  ScriptingOptionsViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 12/29/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ScriptOptionsViewController.h"
#import "ScriptDAO.h"
#import "ScriptCreateEditViewController.h"
#import "ScriptListViewController.h"
#import "ServerListViewController.h"
#import "ScriptResultViewController.h"
@interface ScriptOptionsViewController (){
    
}

@end

@implementation ScriptOptionsViewController
@synthesize options, managedObjectContext, script, server, session;
- (void)viewDidLoad {
    [super viewDidLoad];

    options = [[NSMutableArray alloc] initWithObjects:@"Edit Script", @"Run Script", @"Delete Script",  nil];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem =   self.editButtonItem;
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
    return [options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScriptOptionCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIViewController *vc;
    ScriptCreateEditViewController * scevc;
    ScriptListViewController *slvc;
    UIAlertView *alert;
    ScriptResultViewController *scriptResultViewController;
    ServerListViewController *serverListViewController;
    NSString *response;
    NSError *err=nil;
    switch (indexPath.row) {
            //edit script
        case 0:
            scevc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptCreateEditViewController"];
            [scevc setServer:server];
            [scevc setSession:session];
            [scevc setScript: script];
            [self.navigationController pushViewController:scevc animated:YES];
            break;
            //run script
        case 1:
            if (!session.isConnected || !session.isAuthorized ) {
                alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session is no longer connected. Returning to system list" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                serverListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerListViewController"];
                //if it got fucked up, send them back to the server list to try again
                [self presentViewController:slvc animated:YES completion:^{
                    
                }];
            }
                response = [[session channel] execute:[script script_contents] error:&err];
                
                if (err != nil) {
                    alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occurred executing the script. Please " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    //go back if the command fails
                    [[self navigationController] popViewControllerAnimated:YES];
                    break;
                }
            scriptResultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptResultViewController"];
            [scriptResultViewController setResponse:response];
            [[self navigationController] pushViewController:scriptResultViewController animated:YES];
            
            
            break;
            //Delete script
        case 2:
            [managedObjectContext deleteObject:script];
            [managedObjectContext save:nil];
            [slvc setServer:server];
            [slvc setSession:session];
            slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Script deleted!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self presentViewController:slvc animated:YES completion:nil];
            break;
        default:
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
