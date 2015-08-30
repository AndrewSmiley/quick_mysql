//
//  SelectPackageManagerLinuxViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//
#import "AppDelegate.h"
#import "SelectPackageManagerLinuxViewController.h"
#import "Server.h"
#import "LinuxPackageManager.h"
#import "AptGetInstallNewViewController.h"
#import "AptGetListInstalledViewController.h"
#import "YumInstallNewViewController.h"
#import "YumListInstalledViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
@implementation SelectPackageManagerLinuxViewController
@synthesize tableView, packageManagers, server, session, tempPassword;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [self setTitle:@"Select Package Manager"];
    //    TruckMenuCoreData* truckMenuCoreData = [[TruckMenuCoreData alloc]init];
    //    TruckMenuHTTP* truckMenuHttp = [[TruckMenuHTTP alloc]init];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //    self.managedContext = appDelegate.managedObjectContext;
    //    self.menuItemSearchBar.delegate = self;
    //    self.menuItemTable.delegate = self;
    //    self.menuItemTable.dataSource = self;
    packageManagers = [[NSMutableArray alloc] init];
    NSArray *tmpPMs = [[NSArray alloc] initWithObjects:@"yum", @"apt-get",  nil];
    for (int i  = 0;  i < [tmpPMs count]; i++) {
        LinuxPackageManager * pm = [[LinuxPackageManager alloc] initWithManagerName:[tmpPMs objectAtIndex:i]];
        [packageManagers addObject:pm];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    [[self tableView] setDelegate:self];
    //    [[self tableView] setDataSource:self];
    //fetch the truck menu data from the remote server
    //    [truckMenuHttp fetchAllMenuData:self.managedContext];
    //    menuItems = [truckMenuCoreData getAllMenuItems:self.managedContext];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [packageManagers count];
    
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    // The header for the section is the region name -- get this from the region at the section index.
//    Region *region = [regions objectAtIndex:section];
//    return [region name];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"PackageManagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = [[packageManagers objectAtIndex:indexPath.row] managerName];
    cell.contentView.layer.cornerRadius = 10;
    cell.contentView.layer.masksToBounds = YES;
    //    if (isFiltered) {
    //        TruckMenuItem *item = [filteredMenuItems objectAtIndex:indexPath.row];
    //        cell.textLabel.text = item.title;
    //        cell.textLabel.numberOfLines =2;
    //        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    //
    //        return cell;
    //    }else{
    //        TruckMenuItem *item = [menuItems objectAtIndex:indexPath.row];
    //        cell.textLabel.text = item.title;
    //        cell.textLabel.numberOfLines =2;
    //        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[packageManagers objectAtIndex:indexPath.row]  managerName] isEqualToString: @"apt-get"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Install New Software", @"View Installed Software", nil];
        [alert setTag:1];
        [alert show];
    }else if ([[[packageManagers objectAtIndex:indexPath.row] managerName] isEqualToString:@"yum"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"What would you like to do?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Install New Software", @"View Installed Software", nil];
        [alert setTag:2];
        [alert show];
        
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            if (alertView.tag == 1) {
                AptGetInstallNewViewController *aginvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AptGetInstallNewViewController"];
                [aginvc setServer:server];
                [aginvc setSession:session];
                [aginvc setTempPassword:tempPassword];
                [self.navigationController  pushViewController:aginvc animated:YES];
            }else if(alertView.tag == 2){
                //do the yum one
                YumInstallNewViewController *yinvc = [self.storyboard instantiateViewControllerWithIdentifier:@"YumInstallNewViewController"];
                [yinvc setServer:server];
                [yinvc setSession:session];
                [yinvc setTempPassword:tempPassword];
                [self.navigationController pushViewController:yinvc animated:YES];
            } 
            break;
        case 2:
            if (alertView.tag == 1) {
                AptGetListInstalledViewController *aplivc = [self.storyboard instantiateViewControllerWithIdentifier:@"AptGetListInstalledViewController"];
                
//                AptGetInstallNewViewController *aginvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AptGetInstallNewViewController"];
                [aplivc setServer:server];
                [aplivc setSession:session];
                [aplivc setTempPassword:tempPassword];
                [self.navigationController  pushViewController:aplivc animated:YES];
            }else if(alertView.tag == 2){
                //do the yum one
                YumListInstalledViewController * ylivc = [self.storyboard instantiateViewControllerWithIdentifier:@"YumListInstalledViewController"];
                [ylivc setSession:session];
                [ylivc setServer:server];
                [ylivc setTempPassword:tempPassword];
                [self.navigationController pushViewController:ylivc animated:YES];
            }
            break;
        
            
        default:
            break;
    }
    
    
}

@end