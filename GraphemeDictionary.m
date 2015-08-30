//
//  GraphemeDictionary.m
//  Server Manager
//
//  Created by Andrew Smiley on 2/9/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "GraphemeDictionary.h"

@implementation GraphemeDictionary
@synthesize keys;
-(id) init{
    keys = [[NSMutableDictionary alloc] init];
    return self;
}

-(void) addKey:(NSString *)key{
    [keys setObject:[[NSMutableArray alloc] init] forKey:key];
    
}
-(NSMutableArray *) getValuesAtKey:(NSString *)key{
    return [keys  objectForKey:key];
    
}

-(void) addToKey: (NSString *) key : (NSString *) value{
    
    NSMutableArray *tmpArray = [keys objectForKey:key];
    if (tmpArray == nil) {
        tmpArray = [[NSMutableArray alloc] init];
    }
    [tmpArray addObject:value];
    [keys setObject:tmpArray forKey:key];
}

-(id) initWithKey: (NSString *) key{
    keys = [[NSMutableDictionary alloc] init];
    [keys setObject:[[NSMutableArray alloc ] init] forKey:key];
    
    return self;
}
-(id) initWithKeyValue: (NSString *) key : (NSString *) value{
    keys = [[NSMutableDictionary alloc] init];
    [keys setObject:[[NSMutableArray alloc ] initWithObjects:value, nil] forKey:key];
    return self;
}

-(NSMutableArray *) getMatches:(NSString *) grapheme{
//    NSString *predicateString;
//    if ([grapheme containsString:@"+"]) {
//        NSArray *tmpArray = [grapheme componentsSeparatedByString:@"+"];
//        predicateString = [[NSString alloc] initWithFormat:@"/%@/+/%@/", tmpArray[0], tmpArray[1]];
//        
//    }else{
//        predicateString = [[NSString alloc] initWithFormat:@"/%@/", grapheme];
//    }
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    NSArray *keyCollection = [keys allKeys];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] && (SELF.length-[c].length < 4)",predicateString];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@",grapheme];
    NSArray *keysWeWant = [keyCollection filteredArrayUsingPredicate:predicate];
    for (NSString * k in keysWeWant) {
        NSMutableArray *words=[keys objectForKey:k];
        if ([words count] >= 1) {
            for (NSString *word in words) {
                [matches addObject:word];
            }
        }
        else{
            continue;
        }
    }

    return matches;
}


@end
