//
//  SFTPFileHelper.h
//  Server Manager
//
//  Created by Andrew Smiley on 7/3/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPHelper.h"

@interface SFTPFileHelper : SFTPHelper
@property NSString *filename;
-(id) initWithFilenameAndSession: (NSString *) filename : (NMSSHSession *) session;
-(id) initWithSessionAndSFTPAndPWDAndFileName:(NMSSHSession *) session: (NMSFTP *) sftp: (NSString *) pwd: (NSString *) filename;
-(NSData *) getFileContents;
-(BOOL) saveFileContents:(NSData *)contents: (NSError **) error;
-(NSData *) dataFromString: (NSString *) content;
-(BOOL) removeFile;
-(NSData *) getFileContentsReadOnly;
@end
