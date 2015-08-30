//
//  ServerListViewControllerTableViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/2/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *serverListTableView;
@property NSMutableArray *servers;
@property NSManagedObjectContext *managedObjectContext;
@property bool reloadData;
@end
