//
//  AptGetListInstalledViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "AptGetListInstalledViewController.h"
#import "LinuxSoftware.h"
@interface AptGetListInstalledViewController (){
    BOOL isFiltered;
    NSMutableArray *filteredSoftwares;
}

@end

@implementation AptGetListInstalledViewController
@synthesize session, server, searchBar, daSoftwares, tableView, tempPassword, flags, hud;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Installed Software"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    daSoftwares = [[NSMutableArray alloc] init];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        [hud setLabelText:@"Loading software list"];
        [self.view addSubview:hud];
        [hud setDelegate:self];
        [hud show:YES];
        
    if ([session isConnected]) {
        if ([session isAuthorized]) {
            NSString *getSoftwareListCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S dpkg --get-selections | grep -v deinstall", tempPassword ];
            NSError *error = nil;
            NSString *response = [[session channel] execute:getSoftwareListCommand error:&error];
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                
                NSArray *firstTmp = [response componentsSeparatedByString:@"\n"];
                for (NSString *tmpStr in firstTmp) {
                    NSArray *secondTmp = [tmpStr componentsSeparatedByString:@"\t"];
                    LinuxSoftware *software = [[LinuxSoftware alloc] initWithSoftwareNameAndDescription:[secondTmp objectAtIndex:0] :@"Installed"];
                    [daSoftwares addObject:software];
                }
                
            }
            
            
            
        }
    }
    
});
dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
    //        [self.tableView reloadData];
    NSLog(@"Ok, ");
    [hud hide:YES];
    NSLog(@"So we're hiding the hud");
    [self.tableView reloadData];
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
});
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
    if (isFiltered) {
        return [filteredSoftwares count];
    }else{
        return [daSoftwares count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AptGetInstalledCell" forIndexPath:indexPath];
    
    // Configure the cell...
    //clean this up later..
    if (isFiltered) {
        LinuxSoftware * software = [filteredSoftwares objectAtIndex:indexPath.row];
        cell.textLabel.text = [software softwareName];
        cell.detailTextLabel.text = [software softwareDescription];
        
    }else{
        LinuxSoftware * software = [daSoftwares objectAtIndex:indexPath.row];
        cell.textLabel.text = [software softwareName];
        cell.detailTextLabel.text = [software softwareDescription];
        
    }
    
    return cell;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length == 0){
        isFiltered = NO;
        [tableView reloadData];
        
    }else{
        
        
        isFiltered = YES;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.softwareName contains[cd] %@ or SELF.softwareDescription contains[cd] %@", searchText, searchText];
        filteredSoftwares = [[NSMutableArray alloc] initWithArray:[daSoftwares filteredArrayUsingPredicate:pred]];
        [tableView reloadData];
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *command;
    NSString *response;
    NSError *error = nil;
    NSString *uninstallErrorMessage, *updateErrorMessage;
    uninstallErrorMessage = (isFiltered) ? [[NSString alloc] initWithFormat:@"Could not uninstall %@", [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]] : [[NSString alloc] initWithFormat:@"Could not uninstall %@", [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
    updateErrorMessage = (isFiltered) ? [[NSString alloc] initWithFormat:@"Could not update %@", [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]] : [[NSString alloc] initWithFormat:@"Could not update %@", [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
    NSInteger softwareCount = (isFiltered)? [filteredSoftwares count] : [daSoftwares count];
    
    switch (buttonIndex) {
        case 0:
            break;
            //case if they want to uninstall
        case 1:
            command = (isFiltered) ? [[NSString alloc] initWithFormat:@"echo %@ | sudo -S dpkg --purge %@", tempPassword, [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]] :[[NSString alloc] initWithFormat:@"echo %@ | sudo -S dpkg --purge %@", tempPassword, [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
            response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:uninstallErrorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            break;
            //case they want to upgrade
        case 2:
            command = (isFiltered) ? [[NSString alloc] initWithFormat:@"echo %@ | sudo -S apt-get install --only-upgrade %@", tempPassword, [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]] : [[NSString alloc] initWithFormat:@"echo %@ | sudo -S apt-get install --only-upgrade %@", tempPassword, [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
            response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:updateErrorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }

            
            break;
        default:
            break;
    }

    if (0 <= [alertView tag] <= softwareCount) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
//                controlCommand = (isFiltered) ? [[NSString alloc] initWithFormat:@"echo %@ | sudo -S apt-get", tempPassword]: ;
                break;
            default:
                break;
        }

    }else{
        
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFiltered) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Actions for %@", [[filteredSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Uninstall", @"Upgrade", nil];
                             
        [alert setTag:indexPath.row];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Actions for %@", [[daSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Uninstall", @"Upgrade", nil];
        
        [alert setTag:indexPath.row];
        [alert show];
    }
}

-(void) updateData{
    [daSoftwares removeAllObjects];
    [filteredSoftwares removeAllObjects];
    NSString *getSoftwareListCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S dpkg --get-selections | grep -v deinstall", tempPassword ];
    NSError *error = nil;
    NSString *response = [[session channel] execute:getSoftwareListCommand error:&error];
    if (error != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        NSArray *firstTmp = [response componentsSeparatedByString:@"\n"];
        for (NSString *tmpStr in firstTmp) {
            NSArray *secondTmp = [tmpStr componentsSeparatedByString:@"\t"];
            LinuxSoftware *software = [[LinuxSoftware alloc] initWithSoftwareNameAndDescription:[secondTmp objectAtIndex:0] :@"Installed"];
            [daSoftwares addObject:software];
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
