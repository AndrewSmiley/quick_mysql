//
//  SFTPFileHelper.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/3/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPFileHelper.h"

@implementation SFTPFileHelper
-(id) initWithFilenameAndSession: (NSString *) filename : (NMSSHSession *) session{
    _filename = filename;
    return [super initWithSession:session];
}

-(id) initWithSessionAndSFTPAndPWDAndFileName:(NMSSHSession *) session: (NMSFTP *) sftp: (NSString *) pwd: (NSString *) filename{
    _filename = filename;
    return [super initWithSessionAndSFTPAndPWD:session :sftp :pwd];
}



-(NSData *) getFileContents{
    return [[super sftp] contentsAtPath:[[NSString stringWithFormat:@"%@/%@", [super pwd], _filename] stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
}
-(BOOL) saveFileContents:(NSData *)contents: (NSError **) error{
    BOOL result = [[super sftp] writeContents:contents toFileAtPath:[[NSString stringWithFormat:@"%@/%@", [super pwd], _filename] stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
    return result;
}

-(NSData *) dataFromString: (NSString *) content{
    return [content dataUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL) removeFile{
    return [[super sftp] removeFileAtPath:[[NSString stringWithFormat:@"%@/%@", [super pwd], _filename] stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
}

-(NSData *) getFileContentsReadOnly{
    NSError *err = nil;
    NSString *response = [[[super session] channel] execute:[NSString stringWithFormat:@"cat %@",[[NSString stringWithFormat:@"%@/%@", [super pwd], _filename] stringByReplacingOccurrencesOfString:@"//" withString:@"/"]] error:&err];
    return [response dataUsingEncoding:NSUTF8StringEncoding];
}
@end
