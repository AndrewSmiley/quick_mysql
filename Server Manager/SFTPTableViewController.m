//
//  SFTPTableViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/1/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPTableViewController.h"
#import "SFTPFileViewController.h"
#import "SFTPDirectoryHelper.h"
@interface SFTPTableViewController ()

@end

@implementation SFTPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        NSLog(@"so we loaded the table view controller");
    _sftpHelper = [[SFTPHelper alloc] initWithSession:_session];
    _fileDirectoryList = [_sftpHelper getDirectoryList];
    UIBarButtonItem *upButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backButtonPressed)];
    UIBarButtonItem *newButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newButtonPressed)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeButtonPressed)];
//    self.navigationItem.leftBarButtonItem = upButton;
    self.navigationItem.leftBarButtonItems = @[upButton, newButton];
    self.navigationItem.rightBarButtonItems = @[closeButton,refreshButton];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    [self setTitle:[_sftpHelper pwd]];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    
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
    return [_fileDirectoryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileDirectoryCell" forIndexPath:indexPath];
    NMSFTPFile *obj =  [_fileDirectoryList objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj filename];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [obj permissions]];
//    [obj ]
    // Configure the cell...
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_fileDirectoryList objectAtIndex:indexPath.row] isDirectory]) {
        [_sftpHelper stepIntoDirectory:[[_fileDirectoryList objectAtIndex:indexPath.row] filename]];
        [self reloadFilesAndDirectories];
        
    }else{
        SFTPFileViewController *sftpfvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SFTPFileViewController"];
        [sftpfvc setFilehelper:[[SFTPFileHelper alloc] initWithSessionAndSFTPAndPWDAndFileName:[_sftpHelper session] :[_sftpHelper sftp] :[_sftpHelper pwd] :[[_fileDirectoryList objectAtIndex:indexPath.row] filename]]];
        [sftpfvc setIsCreating:NO];
        [self.navigationController pushViewController:sftpfvc animated:YES];
    }
    
}

-(void) backButtonPressed{
    [_sftpHelper stepOutOfDirectory];
    [self reloadFilesAndDirectories];
    
}

-(void) closeButtonPressed{
    [_sftpHelper closeConnection];
    /*
     When we want to go back to the bottom of the stack FIFO..
     here, we're going back to the server overview
     */
    UIViewController *firstVc = [[[self navigationController] viewControllers] objectAtIndex:1];
    [[self navigationController] setViewControllers:@[firstVc] animated:NO];

    
}
-(void) newButtonPressed{
    SFTPFileViewController *sftpfvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SFTPFileViewController"];
    [sftpfvc setFilehelper:[[SFTPFileHelper alloc] initWithFilenameAndSession:nil :[_sftpHelper session]]];
    [sftpfvc setIsCreating:YES];
    [self.navigationController pushViewController:sftpfvc animated:YES];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NMSFTPFile *fileDir=[_fileDirectoryList objectAtIndex:indexPath.row];
        if ([fileDir isDirectory]) {
            SFTPDirectoryHelper *directoryHelper = [[SFTPDirectoryHelper alloc] initWithDirectoryNameAndSession:[fileDir filename] :[_sftpHelper session]];
            if ([directoryHelper removeDirectory]) {
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Deleted %@ successfully", [fileDir filename]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [self reloadFilesAndDirectories];
            
            }else{
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not delete %@: %@", [fileDir filename], [[[_sftpHelper session] lastError] localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [self reloadFilesAndDirectories];
            }
        }else{
            SFTPFileHelper *fileHelper = [[SFTPFileHelper alloc] initWithFilenameAndSession:[fileDir filename] :[_sftpHelper session]];
            if ([fileHelper removeFile]) {
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Deleted %@ successfully", [fileDir filename]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [self reloadFilesAndDirectories];
            }else{
                UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not delete %@: %@", [fileDir filename], [[[_sftpHelper session] lastError] localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [self reloadFilesAndDirectories];
            }
        }
        
    }
}
-(void) refreshButtonPressed{
    [self reloadFilesAndDirectories];
}
-(void) reloadFilesAndDirectories{
    [_fileDirectoryList removeAllObjects];
    _fileDirectoryList = [_sftpHelper getDirectoryList];
    [self setTitle:[_sftpHelper pwd]];
    [self.tableView reloadData];
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
