//
//  LinuxConsoleHistoryViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 4/12/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "LinuxConsoleHistoryViewController.h"

@interface LinuxConsoleHistoryViewController ()

@end

@implementation LinuxConsoleHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *dataString = [[NSString alloc] init];
    for (NSString *line in _commandHistory) {
        dataString = [NSString stringWithFormat:@"%@%@\n\n",dataString, line];
    }
    [_commandHistoryTxt setText:dataString];
    
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

@end
