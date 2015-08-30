//
//  LinuxPackageManager.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinuxPackageManager : UITableViewController
@property NSString * managerName;
-(id) initWithManagerName: (NSString *) name;
@end
