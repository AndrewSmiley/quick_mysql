    //
//  NewServerViewController.m
//  Server Manager
//
//  Created by Andrew Smiley on 9/12/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "NewServerViewController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Server.h"
#import "ServerDAO.h"
#import "AppDelegate.h"
#import "OperatingSystemDAO.h"
#import "OperatingSystem.h"
#import "OSPackageManager.h"
#import "ServerListViewController.h"
@interface NewServerViewController ()

@end

@implementation NewServerViewController
@synthesize scrollView, connectionNameTxt, hostNameTxt, portTxt, usernameTxt, passwordTxt, osPicker, savePasswordRadio, notesTxt, addServerBtn, serverOptions, managedObjectContext, editing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self setTitle:@"Add New Server"];
    if (editing) {
        [addServerBtn setTitle:@"Update Server" forState:UIControlStateNormal];
        [addServerBtn setTitle:@"Update Server" forState:UIControlStateSelected];
        
    }

    //set the title
    

    //get all the subviews in view
    NSArray * subViews =[scrollView subviews];
    //if the subview is a UITextField, set the delegate to self
    for (int i = 0; i < subViews.count; i++) {
        if ([subViews[i] isMemberOfClass:[UITextField class]]) {
            [subViews[i] setDelegate:self];
        }
    }

    //set the border for the UITextView
    [[notesTxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[notesTxt layer] setBorderWidth:0.5];
    [[notesTxt layer] setCornerRadius:0.5];
    
    
   //add the arguments for the NSArray we'll populate the picker with
//    serverOptions = [[NSArray alloc] initWithObjects:@"Windows", @"Linux", @"MySQL", nil];
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    OperatingSystemDAO *osDAO = [[OperatingSystemDAO alloc] initWithManagedObjectContext:managedObjectContext];
    //    NSArray *OSs = [[NSArray alloc] initWithObjects:@"Windows", @"Linux", @"MySQL", nil];
    NSMutableArray *OSs = [[NSMutableArray alloc] init];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Ubuntu" :@"apt-get"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Debian" :@"apt-get"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"CentOS 7" :@"yum"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"CentOS < 6" :@"yum"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"OpenSUSE" :@"zypper"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Fedora" :@"zypper"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"LinuxMint" :@"apt-get"]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"MySQL" :nil]];
    [OSs addObject:[[OSPackageManager alloc] initWithOSNameAndPM:@"Other Linux" :nil]];
    
    
    [osDAO addAllOperatingSystems:OSs];

    
    serverOptions = [osDAO getAllOperatingSystems];
    //set the delegate methods for the osPicker
    [osPicker setDelegate:self];
    [osPicker setDataSource:self];

    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    
    if (editing == nil) {
        editing  = false;
    }else if(editing == true){
        [self setTitle:[NSString stringWithFormat:@"Editing %@", [_server serverName]]];
        [connectionNameTxt setText:[_server serverName]];
        [hostNameTxt setText:[_server host]];
        [portTxt setText:[NSString stringWithFormat:@"%@", [_server port]]];
        [usernameTxt setText:[_server username]];
        [passwordTxt setText:[_server password]];
        [osPicker selectRow:[[_server operatingSystemID] integerValue] inComponent:0 animated:NO];
        [notesTxt setText:[_server notes]];
        
        //        [portTxt setText:[[NSString stringWithFormat:@"%@",[_server port] ]];
        
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return serverOptions.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    OperatingSystem *os = serverOptions[row];
    return os.operatingSystemName;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if(theTextField == connectionNameTxt){
        [connectionNameTxt resignFirstResponder];
        [hostNameTxt becomeFirstResponder];
        
    }else if (theTextField == hostNameTxt){
        [hostNameTxt resignFirstResponder];
        [portTxt becomeFirstResponder];
        
    }else if(theTextField == portTxt){
        [portTxt resignFirstResponder];
        [usernameTxt becomeFirstResponder];
        
        
    }else if (theTextField == usernameTxt){
        [usernameTxt resignFirstResponder];
        [passwordTxt becomeFirstResponder];
        
    }else if (theTextField == passwordTxt){
        [passwordTxt resignFirstResponder];
    }

    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addServerBtnOnClick:(id)sender {
    //create a new managed object
//    TruckMenuItem *menuItem  =  [[TruckMenuItem alloc] initWithEntity:[NSEntityDescription entityForName:@"TruckMenuItem" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
    if (editing) {
//        Server * server = [[Server alloc] initWithEntity:[NSEntityDescription entityForName:@"Server" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
        //get the values from the input
        [_server setServerName:[connectionNameTxt text]];
        [_server setHost:[hostNameTxt text]];
        [_server setUsername:[usernameTxt text]];
        if (savePasswordRadio.on) {
            [_server setPassword:[passwordTxt text]];
        }else{
            [_server setPassword:Nil];
        }
        //we'll need this to
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * portNumber = [f numberFromString:[portTxt text]];
        [_server setPort:portNumber];
        [_server setNotes:[notesTxt text]];
        //    [osPicker s]
        OperatingSystem *os = [serverOptions objectAtIndex:[osPicker selectedRowInComponent:0]];
        //    [server setOperatingSystemID:portNumber];
        [_server setOperatingSystemID:os.operatingSystemID];
        
        NSError * error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not update server at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            ServerListViewController *slvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServerListViewController"];
            [slvc setReloadData:true];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Updated!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

            /*
             When we want to go back to the bottom of the stack FIFO..
             */
            UIViewController *firstVc = [[[self navigationController] viewControllers] objectAtIndex:0];
            [[self navigationController] setViewControllers:@[firstVc] animated:NO];
        }

    }else{
        Server * server = [[Server alloc] initWithEntity:[NSEntityDescription entityForName:@"Server" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];
        //get the values from the input
        [server setServerName:[connectionNameTxt text]];
        [server setHost:[hostNameTxt text]];
        [server setUsername:[usernameTxt text]];
        if (savePasswordRadio.on) {
            [server setPassword:[passwordTxt text]];
        }else{
            [server setPassword:Nil];
        }
        //we'll need this to
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * portNumber = [f numberFromString:[portTxt text]];
        [server setPort:portNumber];
        [server setNotes:[notesTxt text]];
        //    [osPicker s]
        OperatingSystem *os = [serverOptions objectAtIndex:[osPicker selectedRowInComponent:0]];
        //    [server setOperatingSystemID:portNumber];
        [server setOperatingSystemID:os.operatingSystemID];
        
        NSError * error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Could not save server at this time." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Server Added!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            /*
             When we want to go back to the bottom of the stack FIFO..
             */
            UIViewController *firstVc = [[[self navigationController] viewControllers] objectAtIndex:0];
            [[self navigationController] setViewControllers:@[firstVc] animated:NO];

        }

    }
    
}

-(void)dismissKeyboard {
    [connectionNameTxt resignFirstResponder];
    [hostNameTxt resignFirstResponder];
    [portTxt resignFirstResponder];
    [usernameTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    [notesTxt resignFirstResponder];
}
@end
