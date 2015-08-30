//
//  SQLResultDetailViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 4/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SQLResultDetailViewController.h"

@interface SQLResultDetailViewController ()

@end

@implementation SQLResultDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    //ok, so... basically, we want to create a scroll view and add the data to it
//    NSMutableArray *labels = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [_data count]; i++) {
//        UILabel *label = [[UILabel alloc] init];
//        CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
//        NSString *response = [_data objectAtIndex:i];
//        //    response = [[session channel] lastResponse];
//        //    response = [[session channel] lastResponse];
//        CGSize expectedLabelSize = [response sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
//        
//        //adjust the label the the new height.
//        CGRect newFrame = label.frame;
//        newFrame.size.height = expectedLabelSize.height;
//        label.frame = newFrame;
//        [label setLineBreakMode:NSLineBreakByWordWrapping];
//        label.adjustsFontSizeToFitWidth = YES;
//        label.minimumScaleFactor = 0.5;
//        int lines = 2;
//        //    response = [response stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        //    response = [response stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        //        response = [response stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        //    if (error!=nil) {
//        //        if ([@"" compare:[error localizedDescription]] == NSOrderedSame) {
//        //            //get the occurences of newline characters
//        //            //            if ([[response componentsSeparatedByString:@"\r\n"] count]-1 == 0) {
//        //            //                lines += [[response componentsSeparatedByString:@"\n"] count]-1;
//        //            //                lines += [[response componentsSeparatedByString:@"\r"] count]-1;
//        //            //            }else{
//        //            //                lines +=[[response componentsSeparatedByString:@"\r\n"] count]-1;
//        //            //            }
//        //
//        //            // set number of lines to zero
//        //            //            label.numberOfLines = lines;
//        //            //
//        //            [label setText:response];
//        //        }else{
//        //            //get the occurences of newline characters
//        //            //            if ([[[error localizedDescription] componentsSeparatedByString:@"\r\n"] count]-1 == 0) {
//        //            //                lines += [[[error localizedDescription] componentsSeparatedByString:@"\n"] count]-1;
//        //            //                lines += [[[error localizedDescription] componentsSeparatedByString:@"\r"] count]-1;
//        //            //            }else{
//        //            //                lines +=[[[error localizedDescription] componentsSeparatedByString:@"\r\n"] count]-1 ;
//        //            //            }
//        //            // set number of lines to zero
//        //            //            label.numberOfLines = lines;
//        //
//        //            [label setText:[error localizedDescription]];
//        //        }
//        //
//        //    }else{
//        //get the occurences of newline characters
////        if ([[response componentsSeparatedByString:@"\r\n"] count]-1 == 0) {
////            lines += [[response componentsSeparatedByString:@"\n"] count]-1;
////            lines += [[response componentsSeparatedByString:@"\r"] count]-1;
////        }else{
////            lines +=[[response componentsSeparatedByString:@"\r\n"] count]-1;
////        }
//        
//        //         set number of lines to zero
//        label.numberOfLines = lines;
//        [label setText:response];
//        [label setFont:[label.font fontWithSize:12.0f]];
//        [label sizeToFit];
//        [label setFrame:CGRectMake(20, y_pos, 280, label.frame.size.height)];
//        //    [label setFrame:CGRectMake(20, y_pos, 280, 30*lines)];
//        y_pos += label.frame.size.height;
//        UITextField *t = [[UITextField  alloc] initWithFrame:
//                          CGRectMake(20, y_pos, 280, 30)];
//        
//        // set line break mode to word wrap
//        label.lineBreakMode = UILineBreakModeWordWrap;
//        //get the occurences of newline characters
//        //    int lines = [[response componentsSeparatedByString:@"\n"] count]-1;
//        //    lines += [[respon se componentsSeparatedByString:@"\r"] count]-1;
//        // set number of lines to zero
//        label.numberOfLines = lines;
//        //    [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height*r.frame.size.height)];
//        [scrollView setContentSize:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height+(textFieldOnCommandEnter.frame.size.height*lines)).size];
//        //    NSLog([NSString stringWithFormat:@"height: %f\n",scrollView.frame.size.height ]);
//        [scrollView addSubview:label];
//    }
//    
    
    
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
