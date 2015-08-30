//
//  MySQLError.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/4/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySQLError : NSObject
@property BOOL isError;
@property NSString *description;
@end
