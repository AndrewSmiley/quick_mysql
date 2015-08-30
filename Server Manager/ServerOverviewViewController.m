//
//  ServerOverviewViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/3/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ServerOverviewViewController.h"
#import "Server.h"
#import "ServerDAO.h"
#import "OperatingSystemDAO.h"
#import "AppDelegate.h"
#import "ManageServerLinuxViewController.h"
#import "ManageServerMySQLViewController.h"
#import "NewServerViewController.h"
#import "UIAlertView+Blocks.h"
#import "ServerListViewController.h"
#import <NMSSH/NMSSH.h>
#import "ViewSystemUsageViewController.h"
#import "UIAlertView+Blocks.h"
#import "SFTPTableViewController.h"
@interface ServerOverviewViewController ()

@end

@implementation ServerOverviewViewController
@synthesize serverNameLbl, hostnameLbl, operatingSystemLbl, usernameLbl, server, managedObjectContext;
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    [self setTitle:[server serverName]];
    [serverNameLbl setText:[server serverName]];
    [hostnameLbl setText:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]];
    OperatingSystemDAO *osDAO = [[OperatingSystemDAO alloc] initWithManagedObjectContext:managedObjectContext];
    [operatingSystemLbl setText:[[osDAO getOperatingSystemByOperatingSystemID:[server operatingSystemID]] operatingSystemName]];
    [usernameLbl setText:[server username]];
    
//    OperatingSystemDAO *osDAO = [[OperatingSystemDAO alloc] initWithManagedObjectContext:managedObjectContext];
    if ([[[osDAO getOperatingSystemByOperatingSystemID:[server operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]){
        [_systemOverviewBtn setEnabled:false];
        
    }
//    bool passwordSaved = ([[server password] length] == 0 || [server password] == nil)? false: true;
//    [passwordSavedSwitch setOn: passwordSaved];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editServerOnTouch:(id)sender {
    NewServerViewController * nsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewServerViewController"];
    [nsvc setServer:server];
    [nsvc setEditing:true];
    [self.navigationController pushViewController:nsvc animated:YES];
}


- (IBAction)manageServerOnClick:(id)sender {
    
    OperatingSystemDAO *osDAO = [[OperatingSystemDAO alloc] initWithManagedObjectContext:managedObjectContext];
    if ([[[osDAO getOperatingSystemByOperatingSystemID:[server operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]) {
        ManageServerMySQLViewController *msmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageMySQLServerViewController"];
        [msmvc setServer:server];
        [msmvc setTmpPassword:server.password];
        [self.navigationController pushViewController:msmvc animated:YES];
        
    }else{
    //launch the manage linux server view
    ManageServerLinuxViewController * mslvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageServerLinuxViewController"];
    [mslvc setServer:server];
    [self.navigationController pushViewController:mslvc animated:YES];
    }
    
}

- (IBAction)onDeleteClicked:(id)sender {
    ServerDAO *serverDAO = [[ServerDAO alloc] init];
    ServerListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerListViewController"];
    [slvc setReloadData: true];
    [UIAlertView showWithTitle:@"Alert" message:@"Are you sure?" cancelButtonTitle:@"No" otherButtonTitles:[NSArray arrayWithObjects:@"Yes", nil] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        switch(buttonIndex){
                case 0 :
                
                break;
            case 1:
                if ([serverDAO deleteServer:server :managedObjectContext]) {
                    [UIAlertView showWithTitle:@"Alert" message:@"Server deleted successfully!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        NSLog(@"Server was deleted");
                    }];
                    [self.navigationController pushViewController:slvc animated:YES];
                    
                }else{
                    [self showCouldNotDeleteServer];
                }
                
                break;
        }
    
    }];
     }
     
- (IBAction)systemOverviewOnClick:(id)sender {
    NMSSHSession *session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                                           withUsername:[server username]];
    
    if (!session.isConnected) {
     [UIAlertView showWithTitle:@"Error" message:@"Could not instanciate connection to server" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
         NSLog(@"Could not connect to server");
     }];
    }else{
    ViewSystemUsageViewController *vsucv = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewSystemUsageViewController"];
    [vsucv setServer:server];
    [vsucv setSession:session];
    [self.navigationController pushViewController:vsucv animated:YES];
    }
}

-(void) showCouldNotDeleteServer{
    ServerDAO *serverDAO = [[ServerDAO alloc] init];
    [UIAlertView showWithTitle:@"Alert" message:@"An error occurred deleting the server. Would you like to try again?" cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Try Again", nil] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                return;
                break;
            
            case 1:
                if ([serverDAO deleteServer:server :managedObjectContext]) {
                    [UIAlertView showWithTitle:@"Alert" message:@"Server deleted successfully!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                        NSLog(@"Server was deleted");
                    }];
                }else{
                    [self showCouldNotDeleteServer];
                }
                break;
            default:
                NSLog(@"Something's up... ");
                break;
        }
        
    }];
    
}


- (IBAction)onFileManagerClicked:(id)sender {
    NMSSHSession *session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                                           withUsername:[server username]];
    NSLog(@"Started the initial session");
    [session authenticateByPassword:[server password]];
    NSLog(@"Authenticated");
    NSLog([[session lastError] localizedFailureReason]);
    if (!session.isConnected) {

        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not connect to server: %@", [[session lastError] localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if (session.isAuthorized) {
                NSLog(@"Creating view controller");
            SFTPTableViewController *sftpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SFTPTableViewController"];
                NSLog([NSString stringWithFormat:@"Logged in: %hhd", [session isAuthorized]]);
            [sftpvc setServer:server];
            [sftpvc setSession:session];
            [self.navigationController pushViewController:sftpvc animated:YES];
                NSLog(@"Started push");
            

        }
    }
}
@end
