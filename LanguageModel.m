//
//  LanguageModel.m
//  Server Manager
//
//  Created by Andrew Smiley on 1/25/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//
#import "LanguageModel.h"

@implementation LanguageModel
@synthesize letterSounds,dictionaryWords, phonemeDictionary, graphemeDictionary;
-(id)init{
    letterSounds = [[NSMutableDictionary alloc] init];
    dictionaryWords = [[NSMutableArray alloc] init];
    graphemeDictionary = [[NSMutableDictionary alloc] init];
    phonemeDictionary = [[PhonemeDictionary alloc] init];
    [self getPhonemeDictionary];
    [self getGraphemeDictionary];
    return self;
}
-(void) getWordSounds{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"letter_sounds"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    for (NSString *line in [content componentsSeparatedByString:@"\n"]) {
        if (line==nil || [line isEqualToString:@""]) {
            continue;
        }else{
            NSArray *letter = [line componentsSeparatedByString:@"="];
            NSLog([[NSString alloc] initWithFormat:@"Processing line %@", line]);
            [letterSounds setValue:[letter objectAtIndex:1] forKey:[letter objectAtIndex:0]];

        }
    }
}

-(void)getDictionaryWords{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"dictionary"
                                                     ofType:@"txt"];
    NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    NSLog([[NSString alloc] initWithFormat: @"error %@", error]);
    for (NSString *line in [content componentsSeparatedByString:@"\n"]) {
        [dictionaryWords addObject:line];
        
    }
    
}

/**
 This function gets us the letters of an Individual word
 */
-(NSMutableArray *) getWordLetters: (NSString *) word{
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    [word enumerateSubstringsInRange:NSMakeRange(0, [word length])
                                options:NSStringEnumerationByComposedCharacterSequences
                             usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                 [letters addObject:substring];
                             }];
    return letters;
}

/**
 This function gets us our list of word alternatives for a particular word
 */
-(NSMutableArray *) getWordMatches: (NSMutableArray *) letters{
//    for word in words:
//        if len(word) > 6:
//            break
//            str = ""
//            word = word.lower()
//            letters = list(word)
//            i = 0
//            tmp = len(letters)
//            while i < len(letters):
//                if i == len(letters)-1:
//                    str = str+letter_phonetics[letters[i]]+"|"
//                    break
//                    tmp_key = []
//                    tmp_key.append(letters[i])
//                    done = False
//# base case
//                    str_tmp = "".join(tmp_key)
//                    while not done and i < len(letters)-1:
//                        tmp = tmp_key
//                        tmp.append(letters[i+1])
//                        k = "".join(tmp)
//                        if k in letter_phonetics:
//                            l = letters[i+1]
//                            str_tmp = "".join(tmp)
//                            tmp_key.append(l)
//                            i += 1
//                            else:
//                                done = True
//                                i += 1
//                                
//# letter_itr.pr
//                                
//                                str = str+letter_phonetics[str_tmp]+"|"


    NSMutableArray *matches = [[NSMutableArray alloc] init];
    
    //so first, we want to generate the phonetic sound
    NSMutableArray *phonemes = [[NSMutableArray alloc] init];
    int index = 0;
    //iterate over each of the letters..
    for (int i =0; i < [letters count]; i++) {
        //create a base case, i.e. the letter we are iterating on
        NSString *grapheme = [letters objectAtIndex:i];
        bool stop = false;
        int j = 1;
        while (!stop) {
            NSString *tmpGrapheme =[[[letters subarrayWithRange:NSMakeRange(i, j)] componentsJoinedByString:@""] lowercaseString];
            NSString *result = [graphemeDictionary objectForKey:tmpGrapheme];
            if (result != nil) {
                grapheme = tmpGrapheme;
                j++;
            }
            else{
                i = (j > 2)? i+j: i;
                stop = true;
            }
            if (i >= [letters count]-1) {
                break;
            }
            
        }
        
        NSString *obj = [graphemeDictionary objectForKey:grapheme];
        NSArray *arry = [obj componentsSeparatedByString:@"="];
        [phonemes addObject:arry[0]];
    }
//now we get our works
    for (NSString* string in phonemes) {
        NSString *myString = [string description];
        NSArray *myArray = [myString componentsSeparatedByString:@","];
        for (NSString *l in myArray) {
            NSMutableArray *results = [phonemeDictionary getMatches:l];
            for (NSString *res in results) {
                [matches addObject:res];
            }
        }
        
    }
    return matches;
}

-(void) getPhonemeDictionary{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"words"
                                                     ofType:@"txt"];
    NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    NSLog([[NSString alloc] initWithFormat: @"error %@", error]);
    for (NSString *line in [content componentsSeparatedByString:@"\n"]) {
        NSMutableArray *lineContents = [[NSMutableArray alloc] initWithArray:[line componentsSeparatedByString:@"="]];
        [phonemeDictionary addToKey:[lineContents objectAtIndex:0] :[lineContents objectAtIndex:1]];
        
        
    }
    
}
-(void) getGraphemeDictionary{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"letter_sounds"
                                                     ofType:@"txt"];
    NSError *error = nil;
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
    NSLog([[NSString alloc] initWithFormat: @"error %@", error]);
    int counter = 0;
    for (NSString *line in [content componentsSeparatedByString:@"\n"]) {
        counter++;
        NSMutableArray *lineContents = [[NSMutableArray alloc] initWithArray:[line componentsSeparatedByString:@"="]];
        @try {
                    [graphemeDictionary setObject:[lineContents objectAtIndex:1] forKey:[lineContents objectAtIndex:0]];
        }
        @catch (NSException *exception) {
            NSLog([[NSString alloc] initWithFormat:@"we fucked up on the %d iteration", counter]);
        }
        @finally {
            continue;
        }
    }
}



@end
