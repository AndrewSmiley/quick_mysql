
//  ManageProcessesLinuxViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/6/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import "ManageProcessesLinuxViewController.h"
#import "AppDelegate.h"
#import <NMSSH/NMSSH.h>
#import "Server.h"
#import "LinuxService.h"
@interface ManageProcessesLinuxViewController (){
    NSMutableArray* services;
    NSMutableArray* filteredServices;
    BOOL isFiltered;
}
@end

@implementation ManageProcessesLinuxViewController
@synthesize tableView, searchBar, managedObjectContext, session, tempPassword, server, hud;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Manage Services"];
    services = [[NSMutableArray alloc] init];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    isFiltered = false;
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
          if ([session isAuthorized]) {
        
        [hud setLabelText:@"Loading services"];
        [self.view addSubview:hud];
        [hud setDelegate:self];
        [hud show:YES];
        
        
        
        
        
        NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | ls /etc/init.d/", tempPassword];
        
        NSError *error = nil;
        NSString *response = [[session channel] execute:command error:&error];
        if (error != nil) {
            NSLog(error.localizedDescription);
            [hud hide:YES];
            
            
            
        }else{
            //            services = [NSMutableArray arrayWithArray:[response componentsSeparatedByString:@"\n"]];
            NSMutableArray *strServices  =[[NSMutableArray alloc] initWithArray:[response componentsSeparatedByString:@"\n"]];
            if ([strServices containsObject:@""]) {
                [strServices removeObjectAtIndex:[strServices indexOfObject:@""]];
            }
            for (int i = 0; i < [strServices count]; i++) {
                LinuxService *service = [[LinuxService alloc] initWithServiceName:[strServices objectAtIndex:i]];
                [services addObject:service];
                NSString *statusCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ status", tempPassword, [strServices objectAtIndex:i]];
                NSError *newError;
                NSString *newResponse = [[session channel] execute:statusCommand error:&newError];
                
                if (newError!= nil && (newResponse == nil||[newResponse  isEqual: @""])) {
                    //do stuff
                }else{
                    NSLog([NSString stringWithFormat:@"%@ \n\n", newResponse]);
                    if ([newResponse rangeOfString:@"unrecognized"].location != NSNotFound || [newResponse length] <= 0) {
                        //                        [services removeObjectAtIndex:i];
                        //                        [[services objectAtIndex:i] setSerivceStatus:@"Not Available"];
                    }else{
                        [[services objectAtIndex:i] setServiceStatus:newResponse];
                        
                        //                        [services addObject:tmp];
                    }
                }
                
                //                                NSLog([NSString stringWithFormat:@"%d\n\n\n\n", i]);
                
                
            }
            
            
            
            
            [hud hide:YES];
            //not that I want to do it this way but...
            //
            for (int i = 0; i < [services count]; i++) {
                LinuxService *tmp = [services objectAtIndex:i];
                if ([[[services objectAtIndex:i] serviceStatus] rangeOfString:@"unrecognized"].location != NSNotFound || [[[services objectAtIndex:i] serviceStatus] length] <=0 || [tmp serviceStatus]  == nil || [tmp serviceStatus] == Nil) {
                    [services removeObjectAtIndex:i];
                }
            }
            
            
            
            
            
            
            //well, why don't we try this for now
            //loop over all the services in
            //            for (int i = 0 ; i < [services count]; i++) {
            //
            ////                if([[services objectAtIndex:i] rangeOfString:@"unrecognized"]){
            ////
            ////                }
            //
            //
            //            }
        }
        
    }

        NSLog(@"So we're done loaded");
    });
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
    [self.tableView reloadData];
        NSLog(@"Ok, ");
        [hud hide:YES];
        NSLog(@"So we're hiding the hud");
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
//    dispatch_release(group);

    
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
        return [filteredServices count];
    }else{
        return [services count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcessCell" forIndexPath:indexPath];
    
    if (isFiltered) {
        //        cell.textLabel.text = [filteredServices objectAtIndex:indexPath.row];
        if ([session isAuthorized]) {
            LinuxService *service = [filteredServices objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [service serviceName];
            
            if ([service serviceStatus] == nil) {
                cell.detailTextLabel.text = @"Service status unavailable";
            }else{
                cell.detailTextLabel.text = [service serviceStatus];
            }
            
            
        }
        
    }else{
        //        cell.textLabel.text = [services objectAtIndex:indexPath.row];
        if ([session isAuthorized]) {
            //            NSString *statusCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ status", tempPassword, [services objectAtIndex:indexPath.row]];
            //            NSError *newError;
            //            NSString *newResponse = [[session channel] execute:statusCommand error:&newError];
            //            if (newError!= nil) {
            //                //do stuff
            //            }else{
            //
            //                cell.detailTextLabel.text = newResponse;
            //            }
            LinuxService *service = [services objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [service serviceName];
            
            if ([service serviceStatus] == nil) {
                cell.detailTextLabel.text = @"Service status unavailable";
            }else{
                cell.detailTextLabel.text = [service serviceStatus];
            }
            
        }
    }
    
    
    return cell;
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length == 0){
        isFiltered = NO;
        [tableView reloadData];
        
    }else{
        
     
        isFiltered = YES;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.serviceName contains[cd] %@ or SELF.serviceStatus contains[cd] %@", searchText, searchText];
        filteredServices = [services filteredArrayUsingPredicate:pred];
        [tableView reloadData];
    }
    
    
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar {
    [aSearchBar resignFirstResponder];
}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LinuxService *tmpService;

    if (isFiltered) {
        tmpService = [filteredServices objectAtIndex:indexPath.row];
    }else{
        tmpService = [services objectAtIndex:indexPath.row];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", [tmpService serviceName]] message:@"\nOptions" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Stop", @"Restart", @"Start", nil];
    [alert setTag:indexPath.row];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //this is the callback for the manage service
    NSString *command;
    NSError *error;
    NSString *response;
    NSString *statusCommand;
    NSError *newError = nil;
    NSString *newResponse;
    LinuxService *tmpService;
    NSLog([NSString stringWithFormat:@"%ld\n\n", (long)alertView.tag]);
    if (isFiltered) {
        tmpService = [filteredServices objectAtIndex:alertView.tag];
    }else{
        tmpService = [services objectAtIndex:alertView.tag];
    }
    
    switch (buttonIndex) {
//            isFiltered = false;
        case 0:
            break;
        case 1:
            command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ stop", tempPassword, [tmpService serviceName]];
            error = nil;
            response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not stop service %@",[tmpService serviceName] ] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [newAlert show];
                [tableView reloadData];
            }else{
                //if it's successfull, let's update the status of the service and reload the table data
                statusCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ status ", tempPassword, [tmpService serviceName]];
                newResponse = [[session channel] execute:statusCommand error:&newError];
                if (newError != nil) {
                    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not update status of %@. Status will not be reflected in service view.", [[services objectAtIndex:alertView.tag] serviceName]]delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [newAlert show];
                     [tableView reloadData];
                }else{
                    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Service %@ stopped!", [tmpService serviceName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [newAlert show];
                    [tmpService setServiceStatus:newResponse];
                    if (isFiltered) {
                        [filteredServices replaceObjectAtIndex:[alertView tag] withObject:tmpService];
                    }else{
                        [services replaceObjectAtIndex:[alertView tag] withObject:tmpService];
                    }
                    [tableView reloadData];
                    
                }
                
                
            }
            break;
        case 2:
            
            command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ restart", tempPassword, [[services objectAtIndex:alertView.tag] serviceName]];
            error = nil;
            response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Could not restart service %@",[[services  objectAtIndex:buttonIndex] serviceName] ] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [newAlert show];
                [tableView reloadData];
            }else{
                //if it's successfull, let's update the status of the service and reload the table data
                statusCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ status ", tempPassword, [tmpService serviceName]];
                newResponse = [[session channel] execute:statusCommand error:&newError];
                if (newError != nil) {
                    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not update status of %@. Status will not be reflected in service list.", [[services objectAtIndex:alertView.tag] serviceName]]delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [newAlert show];
                     [tableView reloadData];
                }else{
                    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Service %@ restarted!", [tmpService serviceName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [newAlert show];
                    [tmpService setServiceStatus:newResponse];
                    if (isFiltered) {
                        [filteredServices replaceObjectAtIndex:[alertView tag] withObject:tmpService];
                    }else{
                        [services replaceObjectAtIndex:[alertView tag] withObject:tmpService];
                    }
                                        [tableView reloadData];
                    
                }
                
                
            }
            
            
            break;
            
            case 3:
            command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ start", tempPassword, [tmpService serviceName]];
            error = nil;
            response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not start service %@",[tmpService serviceName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [newAlert show];
                 [tableView reloadData];
            }else{
                //if it's successfull, let's update the status of the service and reload the table data
                statusCommand = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S service %@ status ", tempPassword, [tmpService serviceName]];
                newResponse = [[session channel] execute:statusCommand error:&newError];
                if (newError != nil) {
                    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not update status of %@. Status will not be reflected in service list.", [[services objectAtIndex:alertView.tag] serviceName]]delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [newAlert show];
                     [tableView reloadData];
                }else{
                    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Service %@ started!", [tmpService serviceName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [newAlert show];
                    
                    [tmpService setServiceStatus:newResponse];
                    if (isFiltered) {
                        [filteredServices replaceObjectAtIndex:[alertView tag] withObject:tmpService];
                    }else{
                        [services replaceObjectAtIndex:[alertView tag] withObject:tmpService];
                    }
                                        [tableView reloadData];
                    
                }
                
                
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
