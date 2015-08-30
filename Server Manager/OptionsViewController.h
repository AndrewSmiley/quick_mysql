//
//  OptionsViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 9/12/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UITableViewController  <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *optionsTable;
@property NSArray *options;
@property NSManagedObjectContext *managedObjectContext;
@end
