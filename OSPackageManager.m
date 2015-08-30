//
//  OSPackageManager.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/2/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "OSPackageManager.h"

@implementation OSPackageManager
-(id) initWithOSName:(NSString *)osName{
    self.operatingSystemName = osName;
    return self;
}
-(id) initWithOSNameAndPM:(NSString *)osName :(NSString *)pm{
    self.packageManager = pm;
    self.operatingSystemName = osName;
    return self;
}
@end
