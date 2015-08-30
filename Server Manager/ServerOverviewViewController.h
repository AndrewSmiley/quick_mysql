//
//  ServerOverviewViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/3/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"
@interface ServerOverviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *serverNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *hostnameLbl;
@property (weak, nonatomic) IBOutlet UILabel *operatingSystemLbl;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;

- (IBAction)editServerOnTouch:(id)sender;
- (IBAction)manageServerOnTouch:(id)sender;
- (IBAction)systemOverviewOnClick:(id)sender;
@property Server *server;
@property NSManagedObjectContext* managedObjectContext;
- (IBAction)manageServerOnClick:(id)sender;
- (IBAction)onDeleteClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *systemOverviewBtn;
- (IBAction)onFileManagerClicked:(id)sender;
@end
