//
//  MySQLResult.m
//  Server Manager
//
//  Created by Andrew Smiley on 3/19/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "MySQLResult.h"

@implementation MySQLResult
@synthesize  error, success;
-(id) init{
    error = nil;
    success = false;
    return self;
}

-(id) initWithErrorAndSuccess:(NSString *)error :(BOOL)success{
    [self setError:error];
    [self setSuccess:success];
    return self;
}
@end
