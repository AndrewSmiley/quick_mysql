//
//  MySQLSchema.h
//  Server Manager
//
//  Created by Andrew Smiley on 3/15/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MySQLResult.h"
#import "NSMySQL.h"
@interface MySQLSchema : NSMySQL
-(MySQLResult *) dropSchema;

@end
