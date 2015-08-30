//
//  ViewTableDataViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/22/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mysql.h"
#import "Server.h"
@interface ViewTableDataViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSString *table;
@property NSString *schema;
@property MYSQL connection;
@property Server *server;
@end

