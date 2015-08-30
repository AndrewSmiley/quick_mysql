//
//  VoiceListenerViewController.h
//  Server Manager
//
//  Created by Andrew Smiley on 12/21/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpeechKit/SpeechKit.h>
#import "AppDelegate.h"
#import "ServerDAO.h"
#import "LanguageModel.h"
#import "MBProgressHUD.h"
@interface VoiceListenerViewController : UIViewController <SpeechKitDelegate, SKRecognizerDelegate>
- (IBAction)onStartListeningClick:(id)sender;
- (IBAction)onStopListeningClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *outputText;
@property (strong, nonatomic) SKRecognizer* voiceSearch;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property NSArray *servers;
//@property NSMutableArray *commands;
@property NSManagedObjectContext *managedObjectContext;
@property ServerDAO *serverDAO;
@property LanguageModel *langModel;
@property (weak, nonatomic) IBOutlet UISwitch *reviewCommandSwitch;
@property (weak, nonatomic) IBOutlet UITextField *commandTxt;
- (IBAction)onExecuteCommandClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *executeCommandBtn;
- (IBAction)onHelpClicked:(id)sender;
@property MBProgressHUD *hud;
@end
