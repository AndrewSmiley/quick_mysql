//
//  MySQLTableColumn.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/5/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

/*
Just a container class to store our column information
 */
#import "MySQLTableColumn.h"

@implementation MySQLTableColumn
-(id) initWithDataTypeAndLengthAndName:(NSString *) colType: (NSString *) colName{
    _isPrimaryKey = false;
    _isUnique = false;
    _columnName = colName;
    _dataType = colType;
    _length = nil;
    _decimalPrecision = nil;
    _decimalScale = nil;
    _defaultValue = nil;
    _columnModifiers = [[NSMutableArray alloc] init];
    return self;
}



@end
