//
//  SFTPHelper.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/1/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

/**
 Basically, what I'm thinking for this class is a simple class which tracks our 
 working directory and can spit out the contents of our current directory
 */
#import <Foundation/Foundation.h>
#import <NMSSH/NMSSH.h>
@interface SFTPHelper : NSObject
@property NMSSHSession *session;
@property NSString *pwd;
@property NMSFTP *sftp;
-(id) initWithSession: (NMSSHSession *) sess;
-(id) initWithSessionAndSFTPAndPWD:(NMSSHSession *) session: (NMSFTP *) sftp: (NSString *) pwd;
-(NSMutableArray *) getDirectoryList;
-(NSString *) getPwd: (NSError **) error;
-(void) stepIntoDirectory: (NSString *) directory;
-(void) stepOutOfDirectory;
-(void) closeConnection;
@end
