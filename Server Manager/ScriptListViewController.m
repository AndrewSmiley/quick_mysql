//
//  ScriptingOverviewTableViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 12/28/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "ScriptListViewController.h"
#import "ScriptDAO.h"
#import "AppDelegate.h"
#import "ScriptOptionsViewController.h"
#import "ScriptingOptionsViewControllerTableViewController.h"
#import "ScriptCreateEditViewController.h"
@interface ScriptListViewController (){
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *scripts;
}

@end

@implementation ScriptListViewController
@synthesize server, session;
- (void)viewDidLoad {
    [super viewDidLoad];
    //just a stupid test script added
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    managedObjectContext = appDelegate.managedObjectContext;
    
//    Script *script = [[Script alloc] initWithEntity:[NSEntityDescription entityForName:@"Script" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
//    [script setScript_name:@"Test Script"];
//    [script setScript_contents:@"echo hello"];
    ScriptDAO *scriptDAO = [[ScriptDAO alloc] init];
//    [scriptDAO createNewScript:managedObjectContext :script];
    scripts = [scriptDAO fetchAllScripts:managedObjectContext];
    if ([scripts count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You haven't created any scripts. Would you like to create one now?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Create Script", nil];
        [alert show];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [scripts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScriptCell" forIndexPath:indexPath];
    cell.textLabel.text = [[scripts objectAtIndex:indexPath.row] script_name];
    NSLog([[scripts objectAtIndex:indexPath.row] script_name]);
    return cell;
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    Script *script = [[Script alloc] initWithEntity:[NSEntityDescription entityForName:@"Script" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
    ScriptDAO *scriptDAO = [[ScriptDAO alloc] init];
    ScriptListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
    ScriptCreateEditViewController *scevc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptCreateEditViewController"];
    switch (buttonIndex) {
            //case we don't want to create a new one
        case 0:
            [slvc setServer:server];
            [slvc setSession:session];
            [self.navigationController pushViewController:slvc animated:YES];

            break;
            
        case 1:
            [scevc setSession:session];
            [scevc setServer:server];
            [[self navigationController] pushViewController:scevc animated:YES];
        default:
            break;
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScriptOptionsViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptOptionsViewController"];
    [sovc setScript:[scripts objectAtIndex:indexPath.row]];
    [sovc setManagedObjectContext:managedObjectContext];
    [sovc setSession:session];
    [sovc setServer:server];
    [self.navigationController pushViewController:sovc animated:YES];
    
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
