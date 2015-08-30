//
//  OperatingSystem.h
//  Server Manager
//
//  Created by Andrew Smiley on 11/2/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OperatingSystem : NSManagedObject

@property (nonatomic, retain) NSNumber * operatingSystemID;
@property (nonatomic, retain) NSString * operatingSystemName;
@property (nonatomic, retain) NSString * packageManager;

@end
