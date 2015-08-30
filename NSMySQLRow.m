//
//  MySQLRow.m
//  Server Manager
//
//  Created by Andrew Smiley on 11/22/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "NSMySQLRow.h"

@implementation NSMySQLRow
@synthesize fields;

-(id) init{
    fields = [[NSMutableArray alloc] init];
    return self;
}
-(void) addObject: (NSString *) data{
    [fields addObject:data];
}


-(NSString *) objectAtIndex: (NSInteger *) index{
    //one liner
    return [fields objectAtIndex:index];
    
}


@end
