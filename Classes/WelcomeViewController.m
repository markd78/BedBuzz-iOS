//
//  WelcomeViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Welcome1ViewController.h"
#import "UserModel.h"
#import "SpeakAlarmAppDelegate.h"
#import "ViewHelper.h"
#import "Welcome2EnterNameViewController.h"
#import "SpeakAlarmAppDelegate.h"
#import "LoginService.h"
#import "FacebookModel.h"
#import "PrivacyPolicyViewController.h"

@implementation WelcomeViewController
@synthesize welcome1;
@synthesize welcome2;
@synthesize welcome3;
@synthesize redirectScreen;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    ViewHelper *vh = [ViewHelper sharedManager];
    [vh moveToStartPosition:currentWizardView ForOrientation:toInterfaceOrientation];
    
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [self setWantsFullScreenLayout:YES];

    
    SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window makeKeyAndVisible]; 
    
 
    
    welcome1 = [[Welcome1ViewController alloc] initWithNibName:@"Welcome1" bundle:nil AndReturnTo:self];
    currentWizardView =  welcome1.view;
    ViewHelper *vh = [ViewHelper sharedManager];

    welcome1.view = [vh formatTheViewForWizard:welcome1.view];

    [self.view addSubview:welcome1.view];
    
    [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return YES;
}


-(void) showNextScreen:(int)screen FromCurrentScreen:(int)currentScreen
{
    
    ViewHelper *vh = [ViewHelper sharedManager];
    UserModel *userModel = [UserModel userModel];
    SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginService *loginService;
    FacebookModel *fbModel = [FacebookModel sharedManager];
    
    switch (screen) {
        case welcome2EnterNameScreen:
            welcome2 = [[Welcome2EnterNameViewController alloc] initWithNibName:@"Welcome2EnterName" bundle:nil AndReturnTo:self];
            currentWizardView =  welcome2.view;
            
            welcome2.view = [vh formatTheViewForWizard:welcome2.view];
            
            [self.view addSubview:welcome2.view];
            [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
            break;
        
        case welcome3EnableFacebookScreen:
            welcome3 = [[Welcome3EnableFacebookViewController alloc] initWithNibName:@"Welcome3EnableFacebook" bundle:nil AndReturnTo:self];
            currentWizardView =  welcome3.view;
            
            welcome3.view = [vh formatTheViewForWizard:welcome3.view];
            
            [self.view addSubview:welcome3.view];
            [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];

            break;
         case redirectingToFacebook:
            self.redirectScreen = [[RedirectingToFacebookViewController alloc] initWithNibName:@"RedirectingTofacebook" bundle:nil AndReturnTo:self];
            currentWizardView =  redirectScreen.view;
            
            redirectScreen.view = [vh formatTheViewForWizard:redirectScreen.view];
            
            [self.view addSubview:redirectScreen.view];
            [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
            
            break;

            
        case mainClockScreen:
            
            if (!fbModel.isFetchingID)
            {
                loginService = [[LoginService alloc] init];
                [loginService logOnUserWithBedBuzzID:userModel.userSettings.bedBuzzID andFBID:userModel.userSettings.fbID  AndReturnTo:nil];
            }
           
            
            appDelegate.clockViewController = [[ClockViewController alloc] initWithNibName:@"Clock" bundle:nil]; 
            [self presentModalViewController:appDelegate.clockViewController animated:NO];
            break;
        default:
            break;
    }
}
@end
