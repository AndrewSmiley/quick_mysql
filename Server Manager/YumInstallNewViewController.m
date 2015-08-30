//
//  YumInstallNewViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "YumInstallNewViewController.h"
#import "LinuxSoftware.h"
@interface YumInstallNewViewController (){
    bool isFiltered;
    NSMutableArray *filteredSoftwares;
}

@end

@implementation YumInstallNewViewController
@synthesize searchBar, tableView, tempPassword, daSoftwares, flags, server, session, hud;
- (void)viewDidLoad {
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        [hud setLabelText:@"Loading software list"];
        [self.view addSubview:hud];
        [hud setDelegate:self];
        [hud show:YES];
        
    [super viewDidLoad];
    isFiltered = false;
    [searchBar setDelegate:self];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self setTitle:@"Software Available With Yum"];
    tableView.delegate = self;
    tableView.dataSource = self;
    searchBar.delegate = self;
    daSoftwares = [[NSMutableArray alloc] init];
    if (session.isAuthorized) {
        session.channel.requestPty = YES;
        NSString *getSoftwareCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum list", tempPassword];
        NSError *getSoftwareError = nil;
        NSString *getSoftwareResponse = [[session channel] execute:getSoftwareCommand error:&getSoftwareError];
        if(getSoftwareError != nil){
            NSLog([getSoftwareError localizedDescription]);
        }else{
            NSMutableArray *tmp = [getSoftwareResponse componentsSeparatedByString:@"\r\n"];
//            if ([tmp containsObject:@""]) {
//                [tmp removeObjectAtIndex:[tmp indexOfObject:@""]];
//            }
//            
//            [tmp removeObjectAtIndex:0];
//                    [tmp removeObjectAtIndex:0];
            int counter = 1;
            for (NSString *tmpStr in tmp) {
                [hud setLabelText:[NSString stringWithFormat:@"Loading package %d/%lu", counter, (unsigned long)[tmp count]]];
                counter++;
                if ([tmpStr rangeOfString:@".x86"].location == NSNotFound && [tmpStr rangeOfString:@".noarch"].location == NSNotFound) {
                    continue;
                }else{
                NSArray *data = [tmpStr componentsSeparatedByString:@" "];
                LinuxSoftware *software = [[LinuxSoftware alloc] initWithSoftwareName:[data objectAtIndex:0] ];
                [daSoftwares addObject:software];
                }
            }
            
            
                        NSLog(@"Test");
            
            
        }
        
        
    }
    NSLog(@"So we're done loaded");
});
dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
//    [self.tableView reloadData];
    NSLog(@"Ok, ");
    [hud hide:YES];
     [self.tableView reloadData];
    NSLog(@"So we're hiding the hud");
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
    return (isFiltered)? [filteredSoftwares count] : [daSoftwares count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YumInstallNewCell" forIndexPath:indexPath];
    
    if (isFiltered) {
        cell.textLabel.text = [[filteredSoftwares objectAtIndex:indexPath.row] softwareName];
        
    }else{
        cell.textLabel.text = [[daSoftwares objectAtIndex:indexPath.row] softwareName];
    }
    
    return cell;
}
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered = NO;
        [tableView reloadData];
        [searchBar resignFirstResponder];
        
    }else{
        
        
        isFiltered = YES;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.softwareName contains[cd] %@", searchText];
        filteredSoftwares = [[NSMutableArray alloc] initWithArray:[daSoftwares filteredArrayUsingPredicate:pred]];
        [tableView reloadData];
    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *installCommand;
    NSError *installError = nil;
    NSString *installResponse;
    NSString *installErrorString;
    NSString *installSuccessString;
    if (isFiltered) {
        installSuccessString = [[NSString alloc] initWithFormat:@"%@ was installed successfully", [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
        installCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum install -y %@", tempPassword, [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
    }else{
        installSuccessString = [[NSString alloc] initWithFormat:@"%@ was installed successfully", [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
        installCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S yum install -y %@", tempPassword, [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
    }
    
    switch (buttonIndex) {
            //case for cancel
        case 0:
            break;
            //case for yes
        case 1:
            installResponse = [session.channel execute:installCommand error:&installError];
            if (installError != nil) {
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[installError localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [errorAlert show];
            }
            else{
                UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:installSuccessString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [successAlert show];
                [tableView reloadData];
            }
            break;
            //case for no
        case 2:
            break;
            
        default:
            break;
    }
    
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFiltered) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Would you like to install %@", [[filteredSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"No", nil];
        [alert setTag:indexPath.row];
        [alert performSelectorOnMainThread:@selector(show)
                                withObject:nil
                             waitUntilDone:NO];
//        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Would you like to install %@", [[daSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", @"No", nil];
        [alert setTag:indexPath.row];
        [alert performSelectorOnMainThread:@selector(show)
                                withObject:nil
                             waitUntilDone:NO];
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

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    
}
@end
