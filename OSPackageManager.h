//
//  OSPackageManager.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/2/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSPackageManager : NSObject
@property NSString *operatingSystemName;
@property NSString *packageManager;
-(id) initWithOSName: (NSString *) osName;
-(id) initWithOSNameAndPM:(NSString *)osName:(NSString *) pm;
@end
