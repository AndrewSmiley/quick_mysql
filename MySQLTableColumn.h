//
//  MySQLTableColumn.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/5/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySQLTableColumn : NSObject
-(id) initWithDataTypeAndLengthAndName:(NSString *) colType: (NSString *) colName;
@property NSMutableArray *columnModifiers;
@property NSString *dataType;
@property NSString *length;
@property NSString *columnName;
@property NSString *decimalPrecision;
@property NSString *decimalScale;
@property NSString *defaultValue;
@property BOOL isPrimaryKey;
@property BOOL isUnique;
@property BOOL isAutoIncrement;
@property BOOL isNotNull;
@property BOOL isZeroFill;
@property BOOL isBinary;
@property BOOL isNumeric;
@property BOOL isDecimal;
@end
