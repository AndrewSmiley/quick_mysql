//
//  FirstViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 9/11/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "FirstViewController.h"
#import <UIKit/UIKit.h>
#import <NMSSH/NMSSH.h>
#import "ManageServerMySQLViewController.h"
#import "SchemasListViewController.h"
@interface FirstViewController ()
@end

@implementation FirstViewController
@synthesize commandTxt;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Dispose of any resources that can be recreated.
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
   
}

- (IBAction)onTouchDown:(id)sender {
SchemasListViewController *msmvc=   [[self storyboard] instantiateViewControllerWithIdentifier:@"SchemasListViewController"];
//    [self presentViewController:msmvc animated:YES completion:^{
//        NSLog(@"Launched");
//    }];
    [[self navigationController] pushViewController:msmvc animated:YES];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.color = [UIColor blueColor];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i =0; i < 100000000; i++) {
            NSLog([NSString stringWithFormat:@"%d", i]);
            
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            // stop and remove the spinner on the background when done
            [spinner removeFromSuperview];
        });
    });
//    //so let's real quick just attempt to connect to our ubuntu VM
//    NMSSHSession *session = [NMSSHSession connectToHost:@"devweb.daap.uc.edu:22"
//                                           withUsername:@"pridemai"];
//    
//    if (session.isConnected) {
//        [session authenticateByPassword:@"Tru5tn01"];
//        
//        if (session.isAuthorized) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Connected to server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Connection Refused" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//    }
//    
//    NSError *error = nil;
//    NSString *response = [[session channel] execute:commandTxt.text error:&error];
//    if (error!=nil) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"An Error Occurred. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    NSLog(@"alerttextfiled - %@",alertTextField.text);
    
    // do whatever you want to do with this UITextField.
}

@end
