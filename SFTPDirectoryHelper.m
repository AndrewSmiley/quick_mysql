//
//  SFTPDirectoryHelper.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/4/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPDirectoryHelper.h"
#import <NMSSH/NMSSH.h>
@implementation SFTPDirectoryHelper
-(id) initWithDirectoryNameAndSession: (NSString *) dirName : (NMSSHSession *) session{
    _directoryName = dirName;
    return [super initWithSession:session];
}
-(BOOL) removeDirectory{
    return [[super sftp] removeDirectoryAtPath:[[NSString stringWithFormat:@"%@/%@", [super pwd], _directoryName] stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
}
@end
