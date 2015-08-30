//
//  YumListInstalledViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "YumListInstalledViewController.h"
#import "LinuxSoftware.h"
@interface YumListInstalledViewController ()
{
    bool isFiltered;
    NSMutableArray *filteredSoftwares;
}
@end

@implementation YumListInstalledViewController
@synthesize searchBar, session, server, tableView, flags, tempPassword, daSoftwares,hud;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    [searchBar setDelegate:self];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self setTitle:@"Installed Software"];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        [hud setLabelText:@"Loading software list"];
        [self.view addSubview:hud];
        [hud setDelegate:self];
        [hud show:YES];
    flags = @"";
    daSoftwares = [[NSMutableArray alloc] init];
    if (session.isAuthorized) {
        session.channel.requestPty = YES;
        NSString *getSoftwareCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum list installed", tempPassword];
        NSError *getSoftwareError = nil;
        NSString *getSoftwareResponse = [[session channel] execute:getSoftwareCommand error:&getSoftwareError];
        if(getSoftwareError != nil){
            NSLog([getSoftwareError localizedDescription]);
        }else{
            NSMutableArray *tmp = [getSoftwareResponse componentsSeparatedByString:@"\r\n"];
            if ([tmp containsObject:@""]) {
                [tmp removeObjectAtIndex:[tmp indexOfObject:@""]];
            }
            
            [tmp removeObjectAtIndex:0];
            [tmp removeObjectAtIndex:0];
            for (NSString *tmpStr in tmp) {

                NSArray *data = [tmpStr componentsSeparatedByString:@" "];
                if ([@"" compare:[data objectAtIndex:0]]==NSOrderedSame) {
                    continue;
                }else{
                LinuxSoftware *software = [[LinuxSoftware alloc] initWithSoftwareName:[data objectAtIndex:0] ];
                    [daSoftwares addObject:software];
                }
            }
        }
    }
    
    NSLog(@"So we're done loaded");
});
dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
    //        [self.tableView reloadData];
    NSLog(@"Ok, ");
    [hud hide:YES];
    NSLog(@"So we're hiding the hud");
    [self.tableView reloadData];
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
});
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
    return (isFiltered) ? [filteredSoftwares count] : [daSoftwares count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YumListInstalledCell" forIndexPath:indexPath];
    
    if (isFiltered) {
        cell.textLabel.text = [[filteredSoftwares objectAtIndex:indexPath.row] softwareName];
    }else{
        cell.textLabel.text = [[daSoftwares objectAtIndex:indexPath.row] softwareName];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alert;
    if (isFiltered) {
        alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Would you like to install %@", [[filteredSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update",@"Remove",nil];
    }else{
                alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Would you like to install %@", [[daSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Update",@"Remove",nil];
    }
    [alert setTag:indexPath.row];
    [alert show];
}



-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered = NO;
        [searchBar resignFirstResponder];
        [tableView reloadData];
        
    }else{
        
        
        isFiltered = YES;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.softwareName contains[cd] %@", searchText];
        filteredSoftwares = [[NSMutableArray alloc] initWithArray:[daSoftwares filteredArrayUsingPredicate:pred]];
        [tableView reloadData];
    }
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *updateCommand;
    NSError *updateError=nil;
    NSString *updateResponse;
    //we may want to do something to determine whether the software was updated successfullly or not
    NSString *updateSuccessfulString;
    NSString *uninstallCommand;
    NSError *uninstallError=nil;
    NSString *uninstallResponse;
    NSString *uninstallSuccessfulString;
    if (isFiltered) {
        updateSuccessfulString = [[NSString alloc] initWithFormat:@"%@ updated successfully!", [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
        updateCommand = [NSString stringWithFormat:@"echo %@ | sudo -S yum update -y %@ %@", tempPassword,flags, [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
        uninstallCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum remove -y %@ %@", tempPassword,flags, [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
        uninstallSuccessfulString = [[NSString alloc] initWithFormat:@"%@ removed successfully!", [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
    }else{
        updateSuccessfulString = [[NSString alloc] initWithFormat:@"%@ updated successfully!", [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
        updateCommand = [NSString stringWithFormat:@"echo %@ | sudo -S yum update -y %@ %@", tempPassword,flags, [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
        uninstallCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum remove -y %@ %@", tempPassword, flags, [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
        uninstallSuccessfulString = [[NSString alloc] initWithFormat:@"%@ removed successfully!", [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
    }
    
    switch (buttonIndex) {
        case 0:
            break;
            //case for update
        case 1:
            updateResponse = [[session channel] execute:updateCommand error:&updateError];
            if (updateError != nil) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[updateError localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlert show];
            }else{
                UIAlertView *succesAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:updateSuccessfulString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [succesAlert show];
            }
//            [self updateTableData];
            break;

            //case for remove
        case 2:
            uninstallResponse = [[session channel] execute:uninstallCommand error:&uninstallError];
            if (uninstallError != nil) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[uninstallError localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlert show];
            }else{
                UIAlertView *succesAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:uninstallSuccessfulString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [succesAlert show];
            }
            [self updateTableData];
            break;
            
        default:
            break;
    }
}


-(void) updateTableData{
    if (isFiltered) {
        isFiltered = false;
        [searchBar resignFirstResponder];
    }
    if (session.isAuthorized) {
        session.channel.requestPty = YES;
        NSString *getSoftwareCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum list installed", tempPassword];
        NSError *getSoftwareError = nil;
        NSString *getSoftwareResponse = [[session channel] execute:getSoftwareCommand error:&getSoftwareError];
        if(getSoftwareError != nil){
            NSLog([getSoftwareError localizedDescription]);
        }else{
            NSMutableArray *tmp = [getSoftwareResponse componentsSeparatedByString:@"\n"];
            if ([tmp containsObject:@""]) {
                [tmp removeObjectAtIndex:[tmp indexOfObject:@""]];
            }
            
            [tmp removeObjectAtIndex:0];
            for (NSString *tmpStr in tmp) {
                NSArray *data = [tmpStr componentsSeparatedByString:@" "];
                LinuxSoftware *software = [[LinuxSoftware alloc] initWithSoftwareName:[data objectAtIndex:0] ];
                [daSoftwares addObject:software];
            }
        }
    }
    [tableView reloadData];

}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    
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
