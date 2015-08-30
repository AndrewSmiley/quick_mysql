//
//  ServerListViewControllerTableViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/2/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ServerListViewController.h"
#import "AppDelegate.h"
#import "ServerDAO.h"
#import "Server.h"
#import "ServerOverviewViewController.h"
@interface ServerListViewController ()


@end

@implementation ServerListViewController
@synthesize servers, managedObjectContext;
- (void)viewDidLoad
{
    [self setTitle:@"Server List"];
    self.navigationItem.hidesBackButton = YES;
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    ServerDAO *serverDAO = [[ServerDAO alloc] init];
    servers = [serverDAO getAllServers:managedObjectContext];
//    self.servers = [[NSArray alloc] initWithObjects:@"Add New Server", @"View Server List", nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     Brah, don't remember what this was for...
     */
    if (_reloadData) {
        [self reloadData];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloaddata)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchServers{

    [servers removeAllObjects];
    servers = [[[ServerDAO alloc] init] getAllServers:managedObjectContext];

}

- (void)reloaddata
{
    [self fetchServers];

    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
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
    return [self.servers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ServerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Server *server = [servers objectAtIndex:indexPath.row];
    cell.textLabel.text =server.serverName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@", server.host, server.port];
    cell.textLabel.numberOfLines =2;
    //    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ServerOverviewViewController *sovc = [self.storyboard  instantiateViewControllerWithIdentifier:@"ServerOverviewViewController"];
    [sovc setServer:[servers objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:sovc animated:YES];
    
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
    //    }else if ([[self.options objectAtIndex:indexPath.item] isrEqual:@"Check-In"]){
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

-(void) reloadTableData{
    ServerDAO *serverDAO = [[ServerDAO alloc] init];
    servers = [serverDAO getAllServers:managedObjectContext];
    [self.tableView reloadData];
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
