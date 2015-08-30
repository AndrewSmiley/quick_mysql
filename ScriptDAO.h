//
//  ScriptDAO.h
//  Server Manager
//
//  Created by Andrew Smiley on 12/28/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Script.h"
#import <CoreData/CoreData.h>
@interface ScriptDAO : NSObject

-(BOOL) createNewScript : (NSManagedObjectContext *) context: (Script*) script;
-(NSMutableArray *) fetchAllScripts: (NSManagedObjectContext *) context;
-(BOOL) deleteScript: (NSManagedObjectContext *) context : (Script * ) script;
-(BOOL) updateScript: (NSManagedObjectContext *) context : (Script *) script;

@end
