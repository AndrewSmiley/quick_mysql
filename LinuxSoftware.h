//
//  LinuxSoftware.h
//  Server Manager
//
//  Created by Andrew Smiley on 10/22/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinuxSoftware : NSObject
@property NSString* softwareName;
@property NSString* softwareDescription;
-(id) initWithSoftwareName: (NSString *) sName;
-(id) initWithSoftwareNameAndDescription:(NSString *)sName:(NSString *) sDescription;
@end
