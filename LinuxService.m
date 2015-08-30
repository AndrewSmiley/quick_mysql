//
//  Service.m
//  Server Manager
//
//  Created by Andrew Smiley on 10/7/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "LinuxService.h"

@implementation LinuxService
@synthesize serviceStatus, serviceName;
-(id) initWithServiceName: (NSString *) name{
    serviceName = name;
    return self;
}


@end
