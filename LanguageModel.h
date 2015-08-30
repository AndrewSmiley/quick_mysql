//
//  LanguageModel.h
//  Server Manager
//
//  Created by Andrew Smiley on 1/25/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//
#import "GraphemeDictionary.h"
#import "PhonemeDictionary.h"
#import "WordAlternatives.h"
#import <Foundation/Foundation.h>

@interface LanguageModel : NSObject
-(void) getWordSounds;
-(void) getDictionaryWords;
-(void) getGraphemeDictionary;
@property NSMutableDictionary *letterSounds;
@property PhonemeDictionary *phonemeDictionary;
@property NSMutableDictionary *graphemeDictionary;
@property NSMutableArray *dictionaryWords;
-(id) init;
-(NSMutableArray *) getWordLetters: (NSString *) word;
-(NSMutableArray *) getWordMatches: (NSMutableArray *) letters;
-(void) getPhonemeDictionary;
@end
