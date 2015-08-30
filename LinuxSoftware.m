//
//  LinuxSoftware.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/22/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "LinuxSoftware.h"

@implementation LinuxSoftware
@synthesize softwareDescription, softwareName;
-(id) initWithSoftwareName:(NSString *)sName{
    softwareName = sName;
    softwareDescription = @"";
    return self;
}
-(id) initWithSoftwareNameAndDescription:(NSString *)sName :(NSString *)sDescription{
    softwareDescription = sDescription;
    softwareName = sName;
    return self;
}

@end
