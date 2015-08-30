//
//  LinuxPackageManager.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "LinuxPackageManager.h"

@implementation LinuxPackageManager
@synthesize managerName;
-(id) initWithManagerName:(NSString *)name{
    managerName = name;
    return self;
}
@end
