//
//  VoiceControlCommand.m
//  Server Manager
//
//  Created by Andrew Smiley on 1/24/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import "VoiceControlCommand.h"

@implementation VoiceControlCommand
@synthesize function,command, server,serverAlternativeNames;
-(id) initArgs:(NSString *)cmd :(SEL)funct :(Server *) server{
    serverAlternativeNames = [[NSMutableArray alloc] init];
    [self setFunction:funct];
    [self setCommand:cmd];
    [self setServer: server];
    return self;
}
@end
