//
//  AptGetInstallNewViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "AptGetInstallNewViewController.h"
#import "LinuxSoftware.h"
@interface AptGetInstallNewViewController (){
    BOOL isFiltered;
    NSArray *filteredSoftwares;
    
}

@end

@implementation AptGetInstallNewViewController
@synthesize session, server, searchBar, tableView, daSoftwares, tempPassword, flags,hud;
- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        [hud setLabelText:@"Loading available software"];
        [self.view addSubview:hud];
        [hud setDelegate:self];
        [hud show:YES];
        
    [self setTitle:@"Software Available With Apt-Get"];
    tableView.delegate = self;
    tableView.dataSource = self;
    searchBar.delegate = self;
    daSoftwares = [[NSMutableArray alloc] init];
    if (session.isAuthorized) {
        NSString *getSoftwareCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S apt-cache search .", tempPassword];
        NSError *getSoftwareError = nil;
        NSString *getSoftwareResponse = [[session channel] execute:getSoftwareCommand error:&getSoftwareError];
        if(getSoftwareError != nil){
            NSLog([getSoftwareError localizedDescription]);
        }else{
            NSMutableArray *tmp = [getSoftwareResponse componentsSeparatedByString:@"\n"];
            if ([tmp containsObject:@""]) {
                [tmp removeObjectAtIndex:[tmp indexOfObject:@""]];
            }

            for (NSString *tmpStr in tmp) {
                NSArray *data = [tmpStr componentsSeparatedByString:@" - "];
                LinuxSoftware *software = [[LinuxSoftware alloc] initWithSoftwareNameAndDescription:[data objectAtIndex:0] :[data objectAtIndex:1]];
                [daSoftwares addObject:software];
            }
            
            
//            NSLog(response);
            
            
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AptGetNewSoftwareCell" forIndexPath:indexPath];
    if (isFiltered) {
        LinuxSoftware *software = [filteredSoftwares objectAtIndex:indexPath.row];
        cell.textLabel.text = software.softwareName;
        cell.detailTextLabel.text = software.softwareDescription;

    }else{
        LinuxSoftware *software = [daSoftwares objectAtIndex:indexPath.row];
        cell.textLabel.text = software.softwareName;
        cell.detailTextLabel.text = software.softwareDescription;

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
        filteredSoftwares = [daSoftwares filteredArrayUsingPredicate:pred];
        [tableView reloadData];
    }
    
    
  
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFiltered) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Would you like to install %@?", [[filteredSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert setTag:indexPath.row];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Would you like to install %@?", [[daSoftwares objectAtIndex:indexPath.row] softwareName]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert setTag:indexPath.row];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *command;
    NSString *response;
    NSError *error;
    NSString *errorMessage;
    if (isFiltered) {
        command= [[NSString alloc] initWithFormat:@"echo %@ | sudo -S apt-get -y install %@", tempPassword, [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
        errorMessage = [[NSString alloc] initWithFormat:@"Could not install %@!\n", [[filteredSoftwares objectAtIndex:alertView.tag] softwareName]];
    }else{
        command= [[NSString alloc] initWithFormat:@"echo %@ | sudo -S apt-get -y install %@", tempPassword, [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
                errorMessage = [[NSString alloc] initWithFormat:@"Could not install %@!\n", [[daSoftwares objectAtIndex:alertView.tag] softwareName]];
    }
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
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
