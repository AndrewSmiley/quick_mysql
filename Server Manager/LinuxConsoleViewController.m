//
//  LinuxConsoleViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/6/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "LinuxConsoleViewController.h"
#import "LinuxConsoleHistoryViewController.h"
@interface LinuxConsoleViewController (){
    NSMutableArray *commandHistory;
    NSString *commandResponse;
}

@end

@implementation LinuxConsoleViewController
@synthesize server,session;
- (void)viewDidLoad {
    [super viewDidLoad];
    commandHistory = [[NSMutableArray alloc] init];
    commandResponse = @"";


    // This allocates the textfield and sets its frame
//    UITextField *textField = [[UITextField  alloc] initWithFrame:
//                              CGRectMake(20, y_pos, 280, 30)];
//    [textField setBorderStyle:UITextBorderStyleRoundedRect];
//    [textField setDelegate:self];
//    [scrollView addSubview:textField];
    
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onExecuteCommandClicked:(id)sender {
    [self executeCommand:[_commandTextField text]];
    
}

- (IBAction)onShowCommandHistoryClicked:(id)sender {
    LinuxConsoleHistoryViewController *lchvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LinuxConsoleHistoryViewController"];
    [lchvc setCommandHistory:commandHistory];
    [self.navigationController pushViewController:lchvc animated:YES];
}

/*
 Woo! Executing commands *high pitched voice* mutha fucka!
 */
-(void) executeCommand: (NSString *) commandString{
//    NSLog([NSString stringWithFormat:@"Executing command: %@", commandString]);
    NSString *tempPassword;
    if (session.isConnected) {
        [session authenticateByPassword:[server password]];
        tempPassword = [server password];
        if (session.isAuthorized) {
            NSError *error;
            NSString *response = [[session channel] execute:commandString error:&error];
            if (error != nil) {
                UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errAlert show];
            }else{
                UIAlertView *responseAlert = [[UIAlertView alloc] initWithTitle:@"" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [responseAlert show];
                [commandHistory addObject:commandString];
                [commandHistory addObject:response];
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

-(void) dismissKeyboard{
    [_commandTextField resignFirstResponder];
}
@end
