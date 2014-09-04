    //
//  LoginViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/13/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
#import "FacebookModel.h"
#import "EnterYourNameViewController.h"
#import "SoundDirector.h"
#import "SpeakAlarmAppDelegate.h"
#import "LoginService.h"
#import "PrivacyPolicyViewController.h"
#import "Reachability.h"
#import "Welcome1ViewController.h"

@implementation LoginViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *userModel = [UserModel userModel];
    
    if ([userModel.userSettings.bedBuzzID isEqualToNumber:[NSNumber numberWithInt:-1]])
    {
        // this is a first time log in 
        
        // first check if user has internet access
        internetReach = [[Reachability reachabilityForInternetConnection] retain];
        [internetReach startNotifier];
        [self updateInterfaceWithReachability: internetReach];

    }
  
     //[self.view addSubview:enterYourNameViewController.view];
     
     //[self.view removeFromSuperview];
     //[appDelegate.rootViewController addSubview:enterYourNameViewController.view];
     // self.view = enterYourNameViewController.view;
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability: internetReach];
}

//Called by Reachability whenever status changes.
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == internetReach)
	{	
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The first time you use BedBuzz you must have internet access.  Connect to the internet and then click OK" delegate: self cancelButtonTitle: nil otherButtonTitles: @"OK",nil, nil];
                [alert show];
                [alert release];
                break;
            }
            default:
            {
                [internetReach stopNotifier];
                
                UserModel *userModel = [UserModel userModel];
                
                pleaseWaitView.hidden = YES;
                
                if (![userModel.userSettings.userFullName isEqualToString:@"TESTUSER"])
                {
                    // play 'thanks for updating 'Bed-Buzz' message
                    SoundDirector *soundDirector = [SoundDirector soundDirector];
                    [soundDirector sayUpdateMessage];
                }
            }
        }
        
         
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   /* if ( interfaceOrientation == UIInterfaceOrientationLandscapeRight ||  interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        // moving to portrait
         dontHaveFacebookBtn.frame = CGRectMake(770, 600, 150, 150);
    }
    else
    {
        // moving to landscape
    }*/
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        
        return YES;
    }
    else
    {
        return ( interfaceOrientation == UIInterfaceOrientationLandscapeRight ||  interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    }
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


/**
 * Login/out button click
 */
- (IBAction) fbButtonClick: (id) sender {
	pleaseWaitView.hidden = NO;
	FacebookModel *model = [FacebookModel sharedManager];
	[model fbLoginAndReturnTo:self];
}

/**
 * Doesn't have fb :(
 */
- (IBAction) dontHaveFBButtonClick: (id) sender {
	
    
	// go to enter your name screen
	// show the 'enter your name' dialog
	EnterYourNameViewController *enterYourNameViewController = [[EnterYourNameViewController alloc] initWithNibName:@"EnterYourName" bundle:nil withName:@""];
	//[self.view addSubview:enterYourNameViewController.view];
    
    //[self.view removeFromSuperview];
    //[appDelegate.rootViewController addSubview:enterYourNameViewController.view];
   // self.view = enterYourNameViewController.view;
	[self presentModalViewController:enterYourNameViewController animated:NO];
}

-(void) facebookLoggedIn
{
		// now get user's name
	FacebookModel *model = [FacebookModel sharedManager];
	[model getNameOfUserAndReturnTo:self];
    
}

-(void) facebookGotUserName:(NSString*)name andID:(NSString*)facebookID 
{
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *fbIDNum = [f numberFromString:facebookID];
	[f release];
	
	UserModel *userModel = [UserModel userModel];
	// save to model
	[userModel.userSettings setFbID:fbIDNum ];	
	[userModel.userSettings setUserFullName:name];
	
    
    [userModel saveUserSettings];

    
	
	// log in to bed Buzz Server
	LoginService *loginService = [[LoginService alloc] init];
	[loginService logOnUserWithBedBuzzID:userModel.userSettings.bedBuzzID andFBID:userModel.userSettings.fbID  AndReturnTo:self];
	
	
}

-(void) userLoggedIn
{
	// Now load the main screen
	// and get rid of this screen
	/*[self.view removeFromSuperview];
	
	SpeakAlarmAppDelegate *speakAlarmAppDelegate = (SpeakAlarmAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[speakAlarmAppDelegate showScreen];*/
    pleaseWaitView.hidden = YES;
    UserModel *userModel = [UserModel userModel];
    EnterYourNameViewController *enterYourNameViewController = [[EnterYourNameViewController alloc] initWithNibName:@"EnterYourName" bundle:nil withName:userModel.userSettings.userFullName];
	//[self.view addSubview:enterYourNameViewController.view];
    [self presentModalViewController:enterYourNameViewController animated:NO];
    
    
}

-(IBAction) privacyPolicyButtonPressed: (id) sender
{
    PrivacyPolicyViewController *privacyPolicyViewController = [[PrivacyPolicyViewController alloc] initWithNibName:@"PrivacyPolicy" bundle:nil ];
	[self.view addSubview:privacyPolicyViewController.view];
}

@end
