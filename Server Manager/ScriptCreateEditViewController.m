//
//  ScriptCreateEditViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 12/29/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ScriptCreateEditViewController.h"
#import "AppDelegate.h"
#import "ScriptListViewController.h"
@interface ScriptCreateEditViewController (){
    BOOL isCreating;
}

@end

@implementation ScriptCreateEditViewController
@synthesize scriptContentsTxt, scriptNameTxt, script, managedObjectContext, scriptDAO,session,server;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    managedObjectContext = appDelegate.managedObjectContext;
    if (script != nil) {
        [scriptNameTxt setText:[script script_name]];
        [scriptContentsTxt setText:[script script_contents]];
        isCreating = false;
    }else{
        [scriptNameTxt setPlaceholder:@"My Script"];
        script = [[Script alloc] initWithEntity:[NSEntityDescription entityForName:@"Script" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
        isCreating = true;
    }
    [scriptContentsTxt setDelegate:self];
    [scriptNameTxt setDelegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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

- (IBAction)onSaveBtnClick:(id)sender {

    ScriptDAO *tmp = [[ScriptDAO alloc ] init];
    scriptDAO = tmp;
    UIAlertView *alert;
    //we may need to do something to update vs create new
    if (isCreating) {
        [script setScript_name:[scriptNameTxt text]];
        [script setScript_contents:[scriptContentsTxt text]];
        if([scriptDAO createNewScript:managedObjectContext :script]){
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Script updated!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            ScriptListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
            [slvc setServer:server];
            [slvc setSession:session];
            [self.navigationController pushViewController:slvc animated:YES];
            
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save script." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            ScriptListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
            [slvc setServer:server];
            [slvc setSession:session];
            [self.navigationController pushViewController:slvc animated:YES];

            
        }

    }else{
//        [managedObjectContext insertObject:script];
        [script setValue:[scriptNameTxt text] forKey:@"script_name"];
        [script setValue:[scriptContentsTxt text] forKey:@"script_contents"];
        NSError *err = nil;
        [managedObjectContext save:nil];
        if(err == nil){
            alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Script updated!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            ScriptListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
            [slvc setServer:server];
            [slvc setSession:session];
            [self.navigationController pushViewController:slvc animated:YES];
            
        }else{
            ScriptListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScriptListViewController"];
            [slvc setServer:server];
            [slvc setSession:session];
            [self.navigationController pushViewController:slvc animated:YES];
            alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not save script." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }

        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

    if (theTextField == scriptNameTxt) {
        [scriptNameTxt resignFirstResponder];
        [scriptContentsTxt becomeFirstResponder];
        
    }else {
        
        [theTextField resignFirstResponder];
        
    }
    
    return YES;
}

-(void)dismissKeyboard {
    [scriptNameTxt resignFirstResponder];
    [scriptContentsTxt resignFirstResponder];
}

@end
