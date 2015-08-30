//
//  ScriptResultViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/12/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "ScriptResultViewController.h"

@interface ScriptResultViewController (){
    
}

@end

@implementation ScriptResultViewController
@synthesize response;

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [textView setText:response];
    [textView setEditable:false];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
