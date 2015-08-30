//
//  WordAlternatives.h
//  Server Manager
//
//  Created by Andrew Smiley on 2/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordAlternatives : NSObject
@property NSString* word;
@property NSMutableArray *wordAlertnativesUnsorted;
@property NSMutableArray *wordAlternatives;
-(id) init;
-(id) initWithWord: (NSString *) _word;

@end
