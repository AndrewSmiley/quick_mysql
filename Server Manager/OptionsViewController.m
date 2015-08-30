//
//  OptionsViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 9/12/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "OptionsViewController.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "OperatingSystemDAO.h"
#import "OperatingSystem.h"
#import "OSPackageManager.h"
@interface OptionsViewController ()

@end

@implementation OptionsViewController
@synthesize options, managedObjectContext;
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
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.options = [[NSArray alloc] initWithObjects:@"Add New Server", @"View Server List", nil];
    
    OperatingSystemDAO *osDAO = [[OperatingSystemDAO alloc] initWithManagedObjectContext:managedObjectContext];
//    NSArray *OSs = [[NSArray alloc] initWithObjects:@"Windows", @"Linux", @"MySQL", nil];
    NSMutableArray *OSs = [[NSMutableArray alloc] init];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Windows" :nil]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Ubuntu" :@"apt-get"]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Debian" :@"apt-get"]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"CentOS" :@"yum"]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"OpenSUSE" :@"zypper"]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Fedora" :@"zypper"]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"LinuxMint" :@"apt-get"]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"MySQL" :nil]];
        [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Other Linux" :nil]];
    
    
    [osDAO addAllOperatingSystems:OSs];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OptionsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines =2;
    //    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    DetailVC *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    //    dvc.tweet = [self.tweetsArray objectAtIndex:indexPath.row];
    //    [self.navigationController pushViewController:dvc animated:YES];
    //
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TITLE" message:[self.options objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    //
//    if ([[self.options objectAtIndex:indexPath.item]  isEqual: @"Login"]) {
//        LoginViewController* lvc = [self.storyboard instantiateViewControllerWithIdentifier:[self.options objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:lvc animated:YES];
//        
//    }else if ([[self.options objectAtIndex:indexPath.item] isEqual:@"About"]){
//        AboutViewController* lvc = [self.storyboard instantiateViewControllerWithIdentifier:[self.options objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:lvc animated:YES];
//        
//    }else if ([[self.options objectAtIndex:indexPath.item] isEqual:@"Add Menu Item"]){
//        AddMenuItemViewController* lvc = [self.storyboard instantiateViewControllerWithIdentifier:[self.options objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:lvc animated:YES];
//        
//    }else if ([[self.options objectAtIndex:indexPath.item] isEqual:@"Check-In"]){
//        CheckInViewController* lvc = [self.storyboard instantiateViewControllerWithIdentifier:[self.options objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:lvc animated:YES];
//        
//    }else if ([[self.options objectAtIndex:indexPath.item] isEqual:@"Contact"]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:admin@cincyfoodtruckapp.com"]];
//        
//    }else if ([[self.options objectAtIndex:indexPath.item] isEqual:@"Change Password"]){
//        ChangePasswordViewController* lvc = [self.storyboard instantiateViewControllerWithIdentifier:[self.options objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:lvc animated:YES];
//        
//    }
    
    
    
    
}

/*
#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
