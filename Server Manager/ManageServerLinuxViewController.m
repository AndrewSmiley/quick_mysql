//
//  ManageServerLinuxViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/5/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ManageServerLinuxViewController.h"
#import <NMSSH/NMSSH.h>
#import "Server.h"
#import "ServerDAO.h"
#import "AppDelegate.h"
#import "ManageProcessesLinuxViewController.h"
#import "SelectPackageManagerLinuxViewController.h"
#import "LinuxConsoleViewController.h"
#import "ScriptingOptionsViewControllerTableViewController.h"

@interface ManageServerLinuxViewController ()
@end

@implementation ManageServerLinuxViewController
@synthesize server, tempPassword, session;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.hidesBackButton = YES;
    [self setTitle:[server serverName]];
    //go ahead and open the session to the linux box
    ServerDAO *serverDAO = [[ServerDAO alloc] init];
//    [session ]
  session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                                           withUsername:[server username]];

//    session.channel.requestPty = YES;
    if (session.isConnected) {
        if ([serverDAO isPasswordSaved:server]) {
            [session authenticateByPassword:[server password]];
            tempPassword = [server password];
        }else{
            
            
            tempPassword = nil;
            //just continually prompt them until we get a password
            while (tempPassword == nil) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Enter password for %@", [server serverName]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil] ;
                alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [alertView show];

            }
            [session authenticateByPassword:tempPassword];
            
            if (!session.isAuthorized) {
                UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not connect to %@:%@. Please try again", [server host], [server port]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [newAlert show];
            }

        }
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not instanciate connection" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil] ;
//        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
        
    }

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

- (IBAction)rebootOnClick:(id)sender {
    
    if ([session isAuthorized]) {
        NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S reboot", tempPassword];
        
        NSError *error;
        NSString *response = [[session channel] execute:command error:&error];
        if (error != nil) {
            UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [rebootAlert show];
            
        }else{
            UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Reboot Successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [rebootAlert show];
            
        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session is not authorized. Do something bro!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil] ;
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
    }
}

- (IBAction)pingOnClick:(id)sender {
//    if ([session isAuthorized]) {
//        NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S reboot", tempPassword];
//        NSError *error;
//        NSString *response = [[session channel] execute:command error:&error];
//
//    }
    //no idea what to do here...
    

}

- (IBAction)installSoftwareOnClick:(id)sender {
    if ([session isAuthorized]) {
        
        
        ManageProcessesLinuxViewController *mplvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPackageManagerLinuxViewController"];
        [mplvc setSession:session];
        [mplvc setTempPassword:tempPassword];
        [mplvc setServer:server];

        [self.navigationController pushViewController:mplvc animated:YES];
        
        
        //        NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S ls /etc/init.d/", tempPassword];
        //
        //        NSError *error;
        //        NSString *response = [[session channel] execute:command error:&error];
        //        if (error != nil) {
        //            UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //
        //            [rebootAlert show];
        
        //
        //        }else{
        //            UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //
        //            [rebootAlert show];
        //
        //        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session is not authorized. Do something bro!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil] ;
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
    }

}

- (IBAction)servicesOnClick:(id)sender {
    
    
    if ([session isAuthorized]) {
        
        
        SelectPackageManagerLinuxViewController *mplvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ManageProcessesLinuxViewController"];
        [mplvc setSession:session];
        [mplvc setTempPassword:tempPassword];
        [mplvc setServer:server];
        [self.navigationController pushViewController:mplvc animated:YES];


//        NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S ls /etc/init.d/", tempPassword];
//        
//        NSError *error;
//        NSString *response = [[session channel] execute:command error:&error];
//        if (error != nil) {
//            UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            
//            [rebootAlert show];
//            
//        }else{
//            UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            
//            [rebootAlert show];
//            
//        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Session is not authorized. Do something bro!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil] ;
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [alertView show];
    }

}

- (IBAction)openConsoleOnClick:(id)sender {
    LinuxConsoleViewController *lcvc= [self.storyboard instantiateViewControllerWithIdentifier:@"LinuxConsoleViewController"];
    [lcvc setServer:server];
    [lcvc setSession:session];
    [self.navigationController pushViewController:lcvc animated:YES];
}

- (IBAction)openScriptingOnClick:(id)sender {
    ScriptingOptionsViewControllerTableViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptingOptionsViewController"];
    [slvc setSession:session];
    [slvc setServer:server];
    [self.navigationController pushViewController:slvc animated:YES];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if([alertView cancelButtonIndex] != buttonIndex){
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        tempPassword = alertTextField.text;

    }else{
        tempPassword = nil;
        
    }

}



@end
