//
//  OperatingSystemDAO.h
//  Server Manager
//
//  Created by Andrew Smiley on 9/14/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperatingSystem.h"
@interface OperatingSystemDAO : NSObject

-(void) addAllOperatingSystems: (NSArray *) operatingSystems;

-(NSMutableArray *) getAllOperatingSystems;

-(OperatingSystem *) getOperatingSystemByOperatingSystemID: (NSNumber *) osID;

@property NSManagedObjectContext * managedObjectContext;
-(id) initWithManagedObjectContext: (NSManagedObjectContext *) context;
@end
