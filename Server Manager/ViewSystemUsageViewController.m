//
//  ViewSystemUsageViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/28/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ViewSystemUsageViewController.h"

@interface ViewSystemUsageViewController ()

@end

@implementation ViewSystemUsageViewController
@synthesize server, session;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onRAMUsageClicked:(id)sender {
    [self executeCommand:@"cat /proc/meminfo"];
    
}

- (IBAction)onCPUUsageClicked:(id)sender {
    [self executeCommand:@"grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage \"%\"}'"];
}

- (IBAction)onDiskUsageClicked:(id)sender {
    [self executeCommand:@"df -h"];
}



/*
 Woo! Executing commands *high pitched voice* mutha fucka!
 */
-(void) executeCommand: (NSString *) commandString{
    NSLog([NSString stringWithFormat:@"Executing command: %@", commandString]);
    NSString *tempPassword;
    if (session.isConnected) {
        [session authenticateByPassword:[server password]];
        tempPassword = [server password];
        if (session.isAuthorized) {
            NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S %@", tempPassword, commandString];
            NSError *error;
            NSString *response = [[session channel] execute:command error:&error];
            if (error != nil) {
                UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not fetch system status on %@", server.serverName] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errAlert show];
            }else{
                    UIAlertView *responseAlert = [[UIAlertView alloc] initWithTitle:@"" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [responseAlert show];
            }
            
        }else{
            UIAlertView *authAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could authorize session for %@", [server serverName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [authAlert show];
        }
    }else{
        UIAlertView *whatFuckingAlertIsThisForAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not connect to %@", [server serverName]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [whatFuckingAlertIsThisForAlert show];
        
    }
    
    
}




@end
