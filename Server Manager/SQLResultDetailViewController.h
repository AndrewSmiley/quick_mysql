//
//  SQLResultDetailViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 4/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQLResultDetailViewController : UIViewController
@property NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
