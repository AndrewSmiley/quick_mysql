//
//  SFTPHelper.m
//  Server Manager
//
//  Created by Andrew Smiley on 7/1/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "SFTPHelper.h"
NSString *const LS = @"ls";
NSString *const PWD = @"pwd";
@implementation SFTPHelper
-(id) initWithSession:(NMSSHSession *)sess{
        NSLog(@"We hit the constructor for SFTPHelper");
    _session = sess;
    
    _sftp = [NMSFTP connectWithSession:_session];
    
        NSLog(@"We initialized the sftp connection");
    NSLog([[_session lastError] localizedDescription]);
    NSError *err;
    NSString *str=[self getPwd:&err];
    //if we got an error, let's go ahead and set the pwd to the user home directory
    _pwd = (err==nil) ? str : @"/";
    return self;
}

-(id) initWithSessionAndSFTPAndPWD:(NMSSHSession *) session: (NMSFTP *) sftp: (NSString *) pwd{
    _session=session;
    _sftp=sftp;
    _pwd = pwd;
    return self;
}

-(void) play{
    NMSFTP *sftp = [NMSFTP connectWithSession:_session];
    [sftp contentsOfDirectoryAtPath:_pwd];
}

-(NSString *) getPwd: (NSError **) error{
    NSString *response;
    response = [[_session channel] execute:PWD error:error];
    response = [response stringByReplacingOccurrencesOfString:@"\n" withString:@"/"];
    response = [response stringByReplacingOccurrencesOfString:@"\r" withString:@"/"];
    return response;
}

-(void) stepIntoDirectory: (NSString *) directory{
    //just update the current working directory
    [self setPwd:[NSString stringWithFormat:@"%@/%@",_pwd, directory]];
    //just some cleanup
    _pwd = [_pwd stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    _pwd = [_pwd stringByReplacingOccurrencesOfString:@"\n" withString:@"/"];
    _pwd = [_pwd stringByReplacingOccurrencesOfString:@"\r" withString:@"/"];
}
-(void) stepOutOfDirectory{
    NSArray *contents = [_pwd componentsSeparatedByString:@"/"];
    _pwd = @"/";
    for (int i = 0; i < [contents count]-2; i++) {
        if ([[contents objectAtIndex:i] isEqualToString:@""] || [[contents objectAtIndex:i] isEqualToString:@" "] ) {
            continue;
        }
        _pwd = [NSString stringWithFormat:@"%@%@/",_pwd, [contents objectAtIndex:i]];
    }
    _pwd = [_pwd stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    _pwd = [_pwd stringByReplacingOccurrencesOfString:@"\n" withString:@"/"];
    _pwd = [_pwd stringByReplacingOccurrencesOfString:@"\r" withString:@"/"];
    
}

-(NSMutableArray *) getDirectoryList{
        NSLog(@"Getting directory list");
    if (!_sftp.isConnected) {
        NSLog([[_session lastError] localizedDescription]);
        return  [[NSMutableArray alloc] init];
    }
    
    NSArray *data=[_sftp contentsOfDirectoryAtPath:_pwd];

    return [[NSMutableArray alloc] initWithArray:data];
}

-(void) closeConnection{
    [_sftp disconnect];
    [_session disconnect];
}

@end
