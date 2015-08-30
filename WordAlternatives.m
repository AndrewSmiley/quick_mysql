//
//  WordAlternatives.m
//  Server Manager
//
//  Created by Andrew Smiley on 2/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "WordAlternatives.h"

@implementation WordAlternatives
@synthesize wordAlternatives, word, wordAlertnativesUnsorted;
-(id) init{
    wordAlternatives = [[NSMutableArray alloc] init];
    wordAlertnativesUnsorted = [[NSMutableArray alloc] init];
    word = [[NSString alloc] init];
    return self;
}
-(id) initWithWord:(NSString *)_word{
    wordAlternatives = [[NSMutableArray alloc] init];
    wordAlertnativesUnsorted = [[NSMutableArray alloc] init];
    word = word;
    return self;
}
@end
