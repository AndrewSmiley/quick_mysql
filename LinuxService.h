//
//  Service.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/7/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *Just a basic class for holding linux service information
 */
@interface LinuxService : NSObject
@property NSString *serviceName;
@property NSString *serviceStatus;
-(id) initWithServiceName: (NSString *) name;

@end
