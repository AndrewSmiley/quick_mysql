//
//  ScriptDAO.m
//  Server Manager
//
//  Created by Andrew Smiley on 12/28/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ScriptDAO.h"

@implementation ScriptDAO
-(BOOL)createNewScript:(NSManagedObjectContext *)context :(Script *)script{
    NSError * error = nil;
    if (![context save:&error]) {
        return false;
    }else{
        return true;
    }
        
    
}

-(NSMutableArray *) fetchAllScripts:(NSManagedObjectContext *)context{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Script"];
    [fetchRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if ([results count] > 0 & error == nil) {
        return [[NSMutableArray alloc] initWithArray:results];
    }else{
        return [[NSMutableArray alloc] init];
    }
    
    
}

/**
 * Not entirely sure why we're using a boolean here... May need to refractor this
 */
-(BOOL) deleteScript:(NSManagedObjectContext *)context :(Script *)script{
    [context deleteObject:script];
    return true;
    
}

-(BOOL) updateScript:(NSManagedObjectContext *)context :(Script *)script{
    NSError *err=nil;
    [context save:&err];

    return (err == nil);
}
@end
