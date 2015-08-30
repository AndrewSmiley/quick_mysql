//
//  OperatingSystemDAO.m
//  Server Manager
//
//  Created by Andrew Smiley on 9/14/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "OperatingSystemDAO.h"
#import "OperatingSystem.h"
#import "OSPackageManager.h"
@implementation OperatingSystemDAO
@synthesize managedObjectContext;

#pragma mark- custom constructor to init the class with an NSManagedObjectContext object so we don't have to pass one to every function
-(id) initWithManagedObjectContext: (NSManagedObjectContext *) context{
    managedObjectContext = context;
    return self;
}

#pragma mark- Add all operating systems by their string name
-(BOOL)addAllOperatingSystems:(NSArray *)operatingSystems{
//    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (int i =0; i< [operatingSystems count]; i++) {
//        OperatingSystem*tmp=[[OperatingSystem alloc] init];
//        [tmp setOperatingSystemName:@"My tresr"];
//        [tmp setPackageManager:@"apt-get"];
//        NSLog([tmp operatingSystemName]);
        
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"OperatingSystem"];
        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operatingSystemID==%@", [NSNumber numberWithInt:i+1]];
            [fetchRequest setPredicate:predicate];
        NSError *error;
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if ([results count] == 0) {
            
            OperatingSystem *operatingSystem = [[OperatingSystem alloc] initWithEntity:[NSEntityDescription entityForName:@"OperatingSystem" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
            OSPackageManager *ospm = operatingSystems[i];
            
            [operatingSystem setOperatingSystemName:ospm.operatingSystemName];
            [operatingSystem setPackageManager:ospm.packageManager];
            [operatingSystem setOperatingSystemID:[NSNumber numberWithInt:i+1]];
            if([managedObjectContext save:&error]){
                NSLog(@"Saved");
            }           else{
                NSLog(@"Not Saved");
            }
        }
        else{
            continue;
        }
        }

    
    return  YES;
    
}
#pragma mark- Get all operating systems
-(NSMutableArray *) getAllOperatingSystems{

//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"OperatingSystem"];
//    [fetchRequest setPredicate:[NSPredicate predicateWithValue:YES]];
    //    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"truckID == %@", [truck truckID]]];
    //    NSLog([NSString stringWithFormat:@"%@", [truck truckID]]);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"OperatingSystem"];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"operatingSystemID==1"];
//    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if ([results count] > 0 & error == nil) {
        return [[NSMutableArray alloc] initWithArray:results];
    }else{
        return [[NSMutableArray alloc] init];
    }
}


-(OperatingSystem *) getOperatingSystemByOperatingSystemID: (NSNumber *) osID{
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"OperatingSystem"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"operatingSystemID == %@", osID]];
    NSError *error = nil;
    NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    //if the there's more than 1 object, we want to return the first
    //if there's none, return an empty OperatingSystem object
    //if there's one return the object;
    switch ([results count]) {
        case 0:
            return [[OperatingSystem alloc] init];
            break;
        case 1:
            return [results objectAtIndex:0];
            break;
            
        default:
            return [results objectAtIndex:0];
            break;
    }
    
}
@end
