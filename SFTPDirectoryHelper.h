//
//  SFTPDirectoryHelper.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/4/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPHelper.h"

@interface SFTPDirectoryHelper : SFTPHelper
@property NSString *directoryName;
-(id) initWithDirectoryNameAndSession: (NSString *) dirName : (NMSSHSession *) session;
-(BOOL) removeDirectory;
@end
