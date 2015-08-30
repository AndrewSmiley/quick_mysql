//
//  Script.h
//  Server Manager
//
//  Created by Andrew Smiley on 12/28/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Script : NSManagedObject

@property (nonatomic, retain) NSNumber * script_id;
@property (nonatomic, retain) NSString * script_name;
@property (nonatomic, retain) NSString * script_contents;

@end
