//
//  VoiceControlCommand.h
//  Server Manager
//
//  Created by Andrew Smiley on 1/24/15.
//  Copyright (c) 2015 University of Cincinnati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@interface VoiceControlCommand : NSObject
@property SEL function;
@property NSString *command;
@property Server* server;
-(id) initArgs:(NSString *)cmd :(SEL)funct :(Server *) server;
@property NSMutableArray *serverAlternativeNames;
@end
