//
//  SFTPFileViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/3/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPFileViewController.h"
#import "UIAlertView+Blocks.h"
@interface SFTPFileViewController ()

@end

@implementation SFTPFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contents = (!_isCreating) ? [_filehelper getFileContents] : nil;
    NSString *contentStr = (!_isCreating) ? [[NSString alloc] initWithData:_contents encoding:NSUTF8StringEncoding] : @"";
    _filename = [_filehelper filename];
    if (([contentStr isEqualToString:@" "] || [contentStr isEqualToString:@""] || contentStr==nil) && ! _isCreating) {
        [UIAlertView showWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not open file %@:%@. Would you like to try a read-only version?", _filename, [[[_filehelper session] lastError] localizedDescription]] cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                _contents = [_filehelper getFileContentsReadOnly];
                [_saveBtn setUserInteractionEnabled:NO];
                [_fileEditor setEditable:NO];
                
            }
                
            //go back one
            
        }];
    }
    
    [_fileEditor setText:contentStr];
    UIBarButtonItem *dismissKeyboardButton = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss Keyboard" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissKeyboardButtonPressed)];
    self.navigationItem.rightBarButtonItem = dismissKeyboardButton;
    
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

- (IBAction)onSaveFileClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"File name to write" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setText:_filename];
    alert.tag=1;
    [alert show];
}
-(void) dismissKeyboardButtonPressed{
    [_fileEditor resignFirstResponder];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        
        
        if (buttonIndex > 0) {
            [_filehelper setFilename:[[alertView textFieldAtIndex:0] text]];
            NSLog([[alertView textFieldAtIndex:0] text]);
            NSError *err = nil;
            if ([_filehelper saveFileContents:[_filehelper dataFromString:[_fileEditor text]] :&err]) {
                [UIAlertView showWithTitle:nil message:@"File saved!" cancelButtonTitle:@"Ok" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    //go back one
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Could not save file %@:%@", _filename, [[[_filehelper session] lastError] localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        
    }
    
}

@end
