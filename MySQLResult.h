//
//  MySQLResult.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/19/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySQLResult : NSObject
@property NSString *error;
@property BOOL success;
-(id) init;
-(id) initWithErrorAndSuccess: (NSString *) error: (BOOL) success;
@end
