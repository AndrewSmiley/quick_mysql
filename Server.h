//
//  Server.h
//  Server Manager
//
//  Created by Andrew Smiley on 9/14/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Server : NSManagedObject

@property (nonatomic, retain) NSNumber * serverID;
@property (nonatomic, retain) NSString * serverName;
@property (nonatomic, retain) NSString * host;
@property (nonatomic, retain) NSNumber * port;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * operatingSystemID;

@end
