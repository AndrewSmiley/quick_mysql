//
//  VoiceListenerViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 12/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "VoiceListenerViewController.h"
#import <OpenEars/OEAcousticModel.h>
#import <OpenEars/OELanguageModelGenerator.h>
#import <OpenEars/OEPocketsphinxController.h>
#import <Slt/Slt.h>
#import <OpenEars/OEFliteController.h>
#import "AppDelegate.h"
#import "ServerDAO.h"
#import "Server.h"
#import "VoiceControlCommand.h"
#import <NMSSH/NMSSH.h>
#import <AVFoundation/AVFoundation.h>
#import "LanguageModel.h"
#import "OperatingSystemDAO.h"
@interface VoiceListenerViewController (){
    OEFliteController *fliteController;
    Slt *slt;
    LanguageModel *languageModel;
    BOOL isServerSelected;
    Server *selectedServer;
    NSString *cmdString;
    OperatingSystemDAO *osDAO;
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;

    
}

@end
//our api key
const unsigned char SpeechKitApplicationKey[] = {0x09, 0xb0, 0x90, 0x52, 0xf8, 0xe9,0x38, 0xb5, 0x8d, 0xae, 0xa9, 0x92, 0x80, 0x24, 0x70, 0x81, 0x2d, 0x27, 0x34, 0x80, 0xa2, 0x82, 0x44, 0x81, 0x4b, 0xef, 0x4f, 0xf7, 0x85, 0xe6, 0x8c, 0x8e, 0x96, 0x1c, 0xe0, 0x8e, 0x06, 0x19, 0x44, 0x93, 0xc7, 0xed, 0x25, 0x47, 0x12, 0x95, 0xc8, 0x3f, 0xbc, 0xfc, 0xbf, 0x5e, 0x7f, 0x03, 0xdf, 0xca, 0xf2, 0x2e, 0xc1, 0x77, 0x14, 0x4d, 0x05, 0xaa};
@implementation VoiceListenerViewController
@synthesize appDelegate,voiceSearch, managedObjectContext, servers, serverDAO, langModel, commandTxt, executeCommandBtn, reviewCommandSwitch,hud;
- (void)viewDidLoad {

    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        [hud setLabelText:@"Loading voice recognition"];
        [self.view addSubview:hud];
        [hud setDelegate:self];
        [hud show:YES];
        
    cmdString = [[NSString alloc] init];
//    [reviewCommandSwitch setSelected:false];
    [reviewCommandSwitch setOn:false];
    [executeCommandBtn setEnabled:false];
    [commandTxt setEnabled:false];
    isServerSelected = false;
    languageModel = [[LanguageModel alloc] init];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
//    langModel = [[LanguageModel alloc] init];
    self.managedObjectContext = appDelegate.managedObjectContext;
    osDAO = [[OperatingSystemDAO alloc] initWithManagedObjectContext:self.managedObjectContext];
    serverDAO = [[ServerDAO alloc] init];
    servers = [serverDAO getAllServers:managedObjectContext];

    
    [SpeechKit setupWithID:@"NMDPTRIAL_AndrewSmiley20150124201333"
                      host:@"sandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:self];
                [hud setLabelText:@"Connecting to server"];
    // Set earcons to play
    SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
    SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
    SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];

    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];

    /*
     
     Let's put a pin in this for now, and use a more bare minimum approach
     
    commands = [[NSMutableArray alloc] init];
    //we might not want to do this now..
    for (Server * server in servers) {
//        [commands addObject:[[NSString alloc] initWithFormat:@"reboot %@", [server serverName]]];
        [commands addObject:[[VoiceControlCommand alloc] initArgs:[[NSString alloc] initWithFormat:@"shutdown %@", [server serverName]] :@selector(shutdownServer:) : server]];
        [commands addObject:[[VoiceControlCommand alloc] initArgs:[[NSString alloc] initWithFormat:@"restart %@", [server serverName]] :@selector(restartServer:) : server]];
//        [languageModel getWordMatches:[languageModel getWordLetters:[server serverName]]];
//        [commands addObject:[[NSString alloc] initWithFormat:@"shutdown %@", [server serverName]]];
//        [commands addObject:[[NSString alloc] initWithFormat:@"what is the status of %@", [server serverName]]];
        
         
    }
    */
    fliteController = [[OEFliteController alloc] init];
    slt = [[Slt alloc] init];
//    [langModel getWordSounds];
//    [langModel getDictionaryWords];
//    [self readTextFile:@"letter_sounds"];
    

//    AVSpeechSynthesizer *synth2 = [[AVSpeechSynthesizer alloc] init];
//    utterance.rate = 0.4;
//    [synth2 speakUtterance:utterance];
//    [fliteController say:@"Hello world!" withVoice:slt];
//    [appDelegate setupSpeechKitConnection];
//    // Do any additional setup after loading the view.
//
//    [openEarsEventsObserver setDelegate:self];
//    OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
//    [[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
//    NSArray *words = [NSArray arrayWithObjects:@"WORD", @"STATEMENT", @"OTHER WORD", @"A PHRASE", nil];
//    NSString *name = @"NameIWantForMyLanguageModelFiles";
//    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
//    
//
//    if(err == nil) {
//        
//        lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:@"NameIWantForMyLanguageModelFiles"];
//        dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:@"NameIWantForMyLanguageModelFilesDict"];
//        
//    } else {
//        NSLog(@"Error: %@",[err localizedDescription]);
//    }
//    
//    
//    fliteController = [[OEFliteController alloc] init];
//    slt = [[Slt alloc] init];
//    
//    //so basically this is how to make it talk
//    [fliteController say:@"I am your father" withVoice:slt];
    
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
        NSLog(@"So we're done loaded");
        [hud setLabelText:@"Finishing up"];
    });
    dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
//        [self.tableView reloadData];
        NSLog(@"Ok, ");
        [hud hide:YES];
        NSLog(@"So we're hiding the hud");
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    });


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onStartListeningClick:(id)sender {
    //so if we tap record again it will turn off
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        

        
//        if (recognitionType.selectedSegmentIndex == 0) {
//            /* 'Search' is selected */
//            detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
//            recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
//        }
//        else {
//            /* 'Dictation' is selected */
//            detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
//            recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
//        }
//        
        langType = @"en_US";
//        NSLog(@"Recognizing type:'%@' Language Code: '%@' using end-of-speech detection:%d.", recoType, langType, detectionType);
        recoType = SKSearchRecognizerType;
        detectionType = SKShortEndOfSpeechDetection;
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType
                                                delegate:self];
    }


}

- (IBAction)onStopListeningClick:(id)sender {
            [voiceSearch stopRecording];
}


- (void) destroyed {
    // Debug - Uncomment this code and fill in your app ID below, and set
    // the Main Window nib to MainWindow_Debug (in DMRecognizer-Info.plist)
    // if you need the ability to change servers in DMRecognizer
    //
    //[SpeechKit setupWithID:INSERT_YOUR_APPLICATION_ID_HERE
    //                  host:INSERT_YOUR_HOST_ADDRESS_HERE
    //                  port:INSERT_YOUR_HOST_PORT_HERE[[portBox text] intValue]
    //                useSSL:NO
    //              delegate:self];
    //
    // Set earcons to play
    //SKEarcon* earconStart	= [SKEarcon earconWithName:@"earcon_listening.wav"];
    //SKEarcon* earconStop	= [SKEarcon earconWithName:@"earcon_done_listening.wav"];
    //SKEarcon* earconCancel	= [SKEarcon earconWithName:@"earcon_cancel.wav"];
    //
    //[SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    //[SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    //[SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
}

#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
//    [recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
//    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
//    [self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
//    [recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
//    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    if (numOfResults > 0){
//        searchBox.text = [results firstResult];
//        for (NSString *tmp in [results results]) {
//            NSLog([NSString stringWithFormat:@"What was said: %@",tmp]);
//        }
        NSString *res = [results firstResult];
        res = [res lowercaseString];
        BOOL executedCommand = false;
        //check to see if we're setting a default server
        if ([res hasPrefix:@"use"]) {
            for (int i = 0 ; i < [servers count]; i++) {
                NSString *tmp = [[servers objectAtIndex:i] serverName];
                if ([res rangeOfString:[[[servers objectAtIndex:i] serverName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    if ([[[osDAO getOperatingSystemByOperatingSystemID:[[servers objectAtIndex:i ] operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]) {
                        [self speak:@"Cannot use voice control on My sea quill servers"];
                    }
                    selectedServer = [servers objectAtIndex:i];
                    isServerSelected = true;
                    break;
                }
            }
            if (!isServerSelected) {
                [self speak:@"Could not find server matching requested server name"];
            }else{
                //in this case we want to exit the function with the default server set
                return;
            }
            
        }
        
        //just some stupid shit to say 'switch'
        if ([res rangeOfString:@"switch " options:NSCaseInsensitiveSearch].location != NSNotFound) {
            res = [res stringByReplacingOccurrencesOfString:@"switch " withString:@"-"];
        }else if ([res rangeOfString:@"switch " options:NSCaseInsensitiveSearch].location != NSNotFound){
            res = [res stringByReplacingOccurrencesOfString:@"dash " withString:@"-"];
        }
        

        
        if ([res rangeOfString:@"check" options:NSCaseInsensitiveSearch].location != NSNotFound && [res rangeOfString:@"status" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            if (isServerSelected) {
                if ([[[osDAO getOperatingSystemByOperatingSystemID:[selectedServer operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]) {
                    [self speak:@"Cannot use voice control on MySQL servers"];
                    return;
                }
                [self checkSystemStatus:selectedServer];
                return;
            }else{
                for (int i = 0 ; i < [servers count]; i++) {
                    NSString *s = [[[[servers objectAtIndex:i] serverName] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    //if this is correct, then we found the server we want
                    if ([res rangeOfString:s options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        if ([[[osDAO getOperatingSystemByOperatingSystemID:[[servers objectAtIndex:i ] operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]) {
                            [self speak:@"Cannot use voice control on MySQL servers"];
                            return;
                        }
                        [self checkSystemStatus:[servers objectAtIndex:i]];
                        return;
                    }else{
                        continue;
                    }
                    
                }

            
            }
        }


        //here we're putting in the edit commands before execution shit
        if (reviewCommandSwitch.on) {
            //just enable everything
            [commandTxt setEnabled:true];
            [commandTxt setText:res];
            [executeCommandBtn setEnabled:true];
            
            //set our command string
            cmdString = res;
            return;
        }
        
        //if we're not setting a default server, then we can attempt to execute a
        //command on a server
        if (isServerSelected) {
            if ([[[osDAO getOperatingSystemByOperatingSystemID:[selectedServer operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]) {
                [self speak:@"Cannot use voice control on MySQL servers"];
                return;
            }
            [self executeCommand:res :selectedServer];
            executedCommand = true;
        }else{
            for (int i = 0 ; i < [servers count]; i++) {
                NSString *s = [[[servers objectAtIndex:i] serverName] lowercaseString];
                //if this is correct, then we found the server we want
                if ([res rangeOfString:s options:NSCaseInsensitiveSearch].location != NSNotFound) {
                        //execute the command
                    if ([[[osDAO getOperatingSystemByOperatingSystemID:[[servers objectAtIndex:i ] operatingSystemID]] operatingSystemName] isEqualToString:@"MySQL"]) {
                        [self speak:@"Cannot use voice control on MySQL servers"];
                        return;
                    }
                        [self executeCommand:res :[servers objectAtIndex:i]];
                        executedCommand = true;
                }
                
            }

        }
        //if we did not do anything with the server
        if(!executedCommand){
            [self speak:@"No command was executed"];
            
        }
        
//        bool found;
        
//        for (VoiceControlCommand *vcc in commands) {
//            if ([res isEqualToString:[[vcc command] lowercaseString]]) {
//                [self performSelector:[vcc function] withObject:[vcc server]];
//                break;
//            }
//        }
    }
    
    if (results.suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    

    voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    transactionState = TS_IDLE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    if (suggestion) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    voiceSearch = nil;
}

-(void) restartServer: (Server *) server{
    NSLog(@"Restart down server");
    NSString *tempPassword;
    NMSSHSession* session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                                           withUsername:[server username]];
    //    session.channel.requestPty = YES;
    if (session.isConnected) {
        [session authenticateByPassword:[server password]];
        tempPassword=[server password];
//        [session authenticateByPassword:@"hick802acid248"];
//        tempPassword = @"hick802acid248";
        if (session.isAuthorized) {
            NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S reboot now", tempPassword];
            NSError *error;
            NSString *response = [[session channel] execute:command error:&error];
            if (error != nil) {
                [self speak:[NSString stringWithFormat:@"Could not restart %@", [server serverName]]];
                //                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //
                //                    [rebootAlert show];
                //
            }else{
                [self speak:[NSString stringWithFormat:@"Restarted %@ successfully", [server serverName]]];
                //                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Reboot Successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //
                //                    [rebootAlert show];
                
            }
            
        }else{
            [self speak:[NSString stringWithFormat:@"Could authorize session for %@", [server serverName]]];
        }
    }else{
        [self speak:[NSString stringWithFormat:@"Could not connect to %@", [server serverName]]];
        
    }

}

-(void) shutdownServer: (Server *) server{
    NSLog(@"Shutting down server");
    NSString *tempPassword;
    NMSSHSession* session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                             withUsername:[server username]];
    //    session.channel.requestPty = YES;
    if (session.isConnected) {
        [session authenticateByPassword:[server password]];
        tempPassword = [server password];
//        [session authenticateByPassword:@"hick802acid248"];
//        tempPassword = @"hick802acid248";
        if (session.isAuthorized) {
                NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S shutdown now", tempPassword];

                NSError *error;
                NSString *response = [[session channel] execute:command error:&error];
                if (error != nil) {
                    [self speak:[NSString stringWithFormat:@"Could not shutdown %@", [server serverName]]];
//                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    
//                    [rebootAlert show];
//                    
                }else{
                    [self speak:[NSString stringWithFormat:@"Shutdown %@ successfully", [server serverName]]];
//                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Reboot Successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    
//                    [rebootAlert show];
                    
                }
            
        }else{
            [self speak:[NSString stringWithFormat:@"Could authorize session for %@", [server serverName]]];
        }
    }else{
        [self speak:[NSString stringWithFormat:@"Could not connect to %@", [server serverName]]];

    }

}

-(void) speak: (NSString *) text{
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:text];
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    utterance.rate = 0.07;
    [synth speakUtterance:utterance];
}

-(NSString *) readTextFile: (NSString *) name{
    NSString* path = [[NSBundle mainBundle] pathForResource:name
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

-(void) executeCommand: (NSString *) commandString: (Server* ) server{
    NSLog([NSString stringWithFormat:@"Executing command: %@", commandString]);
    NSString *tempPassword;
    NMSSHSession* session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                                           withUsername:[server username]];
    //    session.channel.requestPty = YES;
    if (session.isConnected) {
        [session authenticateByPassword:[server password]];
//        [self speak:[NSString stringWithFormat:@"%@ is running", [server serverName]]];
        tempPassword = [server password];
        if (session.isAuthorized) {
            NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S %@", tempPassword, commandString];
            NSError *error;
            NSString *response = [[session channel] execute:command error:&error];
            if (error != nil) {
                [self speak:[NSString stringWithFormat:@"Could not execute command %@ for reason: %@", commandString, response]];
                //                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //
                //                    [rebootAlert show];
                //
            }else{
                //doesn't have to be a formatted string
//                [self speak:[NSString stringWithFormat:@"Command executed successfully"]];
                
                
                //if the response is greater than 25, show the user the response, otherwise read it to their lazy ass
                if ([response length] > 25) {
                    UIAlertView *responseAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [responseAlert show];
                }else{
                    [self speak:response];
                }
                //                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Reboot Successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                //
                //                    [rebootAlert show];
                
            }
            
        }else{
            [self speak:[NSString stringWithFormat:@"Could authorize session for %@", [server serverName]]];
        }
    }else{
        [self speak:[NSString stringWithFormat:@"Could not connect to %@", [server serverName]]];
        
    }

    
}

-(void) checkSystemStatus: (Server * ) server{
    NMSSHSession* session = [NMSSHSession connectToHost:[NSString stringWithFormat:@"%@:%@", [server host], [server port]]
                                           withUsername:[server username]];
    //    session.channel.requestPty = YES;
    if (session.isConnected) {
        [session authenticateByPassword:[server password]];
        [self speak:[NSString stringWithFormat:@"%@ is running", [server serverName]]];
        if (session.isAuthorized) {
            NSArray *commands = [[NSArray alloc] initWithObjects:@"cat /proc/meminfo",@"grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage \"%\"}'",@"df -h" , nil];
            NSArray *titles = [[NSArray alloc] initWithObjects:@"RAM Utilization",@"CPU Utilization", @"Disk Utilization", nil];
            
            for (int i = 0; i < [commands count]; i++) {
                NSString *command = [[NSString alloc] initWithFormat:@"echo %@ | sudo -S %@", [server password], [commands objectAtIndex:i]];
                NSError *error;
                NSString *response = [[session channel] execute:command error:&error];
                if (error != nil) {
                    [self speak:[NSString stringWithFormat:@"Could not finish fetching %@", [titles objectAtIndex:i]]];
                    //                    UIAlertView *rebootAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    //
                    //                    [rebootAlert show];
                    //
                }else{
                        UIAlertView *responseAlert = [[UIAlertView alloc] initWithTitle:[titles objectAtIndex:i] message:response delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [responseAlert show];
                }

            }
        }else{
            [self speak:[NSString stringWithFormat:@"Could authorize session for %@", [server serverName]]];
        }
    }else{
        [self speak:[NSString stringWithFormat:@"Could not connect to %@", [server serverName]]];
        
    }
    

    
}

- (IBAction)onExecuteCommandClicked:(id)sender {
    //first, disable everything again
    [executeCommandBtn setEnabled:false];
    [commandTxt setEnabled:false];
    cmdString = commandTxt.text;
    if (isServerSelected) {
        [self executeCommand:cmdString :selectedServer];
    }else{
        [self speak:@"You must select a server before you can edit a command"];
    }
    
    
    
}
- (IBAction)onHelpClicked:(id)sender {
}


-(void)dismissKeyboard {
    [commandTxt resignFirstResponder];
}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    
}
@end
