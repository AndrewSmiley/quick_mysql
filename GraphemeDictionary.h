//
//  GraphemeDictionary.h
//  Server Manager
//
//  Created by Andrew Smiley on 2/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
This class functions similar to a Dictionary, however, it allows us to store multiple
 NSStrings in one key: i.e. key=> NSString, value=>NSMutableArray(NSString)
 Maybe I could make this generic and just make a custom dictionary class.. But that's for another day
 */
@interface GraphemeDictionary : NSObject
@property NSMutableDictionary*keys;
-(NSMutableArray *) getValuesAtKey: (NSString *) key;
-(void) addKey: (NSString *) key;
-(id) init;
-(id) initWithKey: (NSString *) key;
-(id) initWithKeyValue: (NSString *) key : (NSString *) value;
-(void) addToKey: (NSString *) key : (NSString *) value;
-(NSMutableArray *) getMatches:(NSString *) grapheme;
@end
