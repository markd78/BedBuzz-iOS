//
//  SpeakAlarmAppDelegate.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SpeakAlarmAppDelegate.h"
#import "ClockViewController.h"
#import "AlarmsModel.h"
#import "WeatherModel.h"
#import "SoundDirector.h"
#import "ClockModel.h"
#import "AlarmGoingOffViewController.h"
#import "UserModel.h"
#import "RootViewController_Old.h"
#import "RSSModel.h"
#import "LoginService.h"
#import "StoreKitModel.h"
#import "Flurry.h"
#import "WelcomeViewController.h"
#import "SendErrorService.h"
#import <AWSCore/AWSCore.h>

@implementation SpeakAlarmAppDelegate

@synthesize window, clockViewController, tabBarController,rootViewController, loginViewController;

	- (void)drawRect:(CGRect)rect
	{
		// get the contect
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		//now draw the rounded rectangle
		CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.0);
		
		//since I need room in my rect for the shadow, make the rounded rectangle a little smaller than frame
		CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect)-30, CGRectGetHeight(rect)-30);
		CGFloat radius = 45;
		// the rest is pretty much copied from Apples example
		CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
		CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
		
		{
			//for the shadow, save the state then draw the shadow
			CGContextSaveGState(context);
			
			// Start at 1
			CGContextMoveToPoint(context, minx, midy);
			// Add an arc through 2 to 3
			CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
			// Add an arc through 4 to 5
			CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
			// Add an arc through 6 to 7
			CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
			// Add an arc through 8 to 9
			CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
			// Close the path
			CGContextClosePath(context);
			
			CGContextSetShadow(context, CGSizeMake(4,-5), 10);
			CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
			
			// Fill & stroke the path
			CGContextDrawPath(context, kCGPathFillStroke);
			
			//for the shadow
			CGContextRestoreGState(context);
		}
		
		{
			// Start at 1
			CGContextMoveToPoint(context, minx, midy);
			// Add an arc through 2 to 3
			CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
			// Add an arc through 4 to 5
			CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
			// Add an arc through 6 to 7
			CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
			// Add an arc through 8 to 9
			CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
			// Close the path
			CGContextClosePath(context);
			
			CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
			CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);       
			
			// Fill & stroke the path
			CGContextDrawPath(context, kCGPathFillStroke);
		}
	
	
}

-(void)facebookLoggedIn
{
    UserModel *userModel = [UserModel userModel];
	[userModel saveUserSettings];
	
	[self showScreen];
    
   }

-(void)showSubscribeWizard
{
     UserModel *userModel = [UserModel userModel];
    if (!userModel.userSettings.isPaidUser)
    {
        [clockViewController showSubscribeQuestion:FALSE];
    }
}

-(void)showAds
{
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [clockViewController showAdBannerForiPad];
    }
   // else
    //{
    //    [clockViewController showAds];
    //}
}

-(void)alarmFinished
{
    [clockViewController alarmFinished];
}

-(void)setUp:(BOOL)fromAlarm
{
    alarmShouldPlay = NO;
    
    if([[UINavigationBar class] respondsToSelector:@selector(appearance)]) //iOS >=5.0
    {
        [[UIScreen mainScreen] setWantsSoftwareDimming:YES];
    }
    
    if (!fromAlarm)
    {
       
        rootViewController = [[RootViewController_Old alloc] initWithNibName:@"RootView" bundle:nil fromAlarmNotification:NO] ;   
       // [window addSubview:rootViewController.view];
        self.window.rootViewController =rootViewController;
        [window makeKeyAndVisible];

    }
	           // creates your table view - this should be a UIViewController with a table view in it, or UITableViewController
        
	StoreKitModel *storKitModel = [StoreKitModel sharedManager];
    [storKitModel getProducts];
	//[storKitModel getIsPaidSubscriptionUser];
    
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector initializeAudioPlayer];
	
	[self loadAlarms];
	
	RSSModel *rssModel = [RSSModel sharedManager];
	[rssModel loadRSSFeeds];
	
	// load the user settings
	UserModel *userModel = [UserModel userModel];
	[userModel loadUserSettings];
    
    ClockModel *clockModel = [ClockModel clockModel];
    
    [clockViewController registerForAlarmGoingOff];
	[clockModel startClock];
    
}




void uncaughtExceptionHandler(NSException *exception) {
    
    NSArray *backtrace = [exception callStackSymbols];
    //NSString *platform = [[UIDevice currentDevice] platform];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *message = [NSString stringWithFormat:@" OS: %@. Backtrace:\n%@",
                         version,
                         backtrace];
    
    SendErrorService *errorSrv = [[SendErrorService alloc] init];
    [errorSrv sendErrorMessage:message];
    
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self applicationDidFinishLaunching:application];
    
    return YES;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
    
    isFromReturnFromFacebookApp = NO;
    [self setUp:NO];
    isAppearingFromBackground = NO;
    isFromNotification = NO;
    
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSWest2 identityPoolId: @"us-west-2:c6eb41ca-b58b-43a6-b0e3-86933bf5c497"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2 credentialsProvider:credentialsProvider];

    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    
   NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
       [Flurry startSession:@"RPXQ4TL19VT299PAVVEN"];
    }
    else
    {
         [Flurry startSession:@"HC6BMLG1YXGVKZUMQ76Z"];
    }

    UserModel *userModel = [UserModel userModel];
    
	// if the user has not been setup yet (did not enter their name) then show the enter your name prompt
	if ([userModel.userSettings.userFullName isEqualToString:@"TESTUSER"])
	{
		// show the 'login' dialog
		//LoginViewController *loginViewController = [[[LoginViewController alloc] initWithNibName:@"LoginWithFacebook" bundle:nil] autorelease];
        loginViewController = [[WelcomeViewController alloc] initWithNibName:@"FirstScreen" bundle:nil];
		//[window addSubview:loginViewController.view];
        [rootViewController.view removeFromSuperview];
        [window makeKeyAndVisible]; 
		self.window.rootViewController = loginViewController;
		
	}
	else {
		
			// log in to bed Buzz Server
			LoginService *loginService = [[LoginService alloc] init];
			[loginService logOnUserWithBedBuzzID:userModel.userSettings.bedBuzzID andFBID:userModel.userSettings.fbID  AndReturnTo:self];
			
		
		
	}
    
	// set the app version
	userModel.userSettings.appVersion = [NSNumber numberWithDouble:2.01];
	[userModel saveUserSettings];
	//[skController autorelease];
    
   
    
    
}

-(void)showRenewAlertWithQuestion:(NSString *)question
{
   
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Renew subsbription?" message:question 
                                                   delegate:self 
                                          cancelButtonTitle:@"Not now" otherButtonTitles:@"Yes please!",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Cancel Tapped.");
    }
    else if (buttonIndex == 1) {
        StoreKitModel *skModel = [StoreKitModel sharedManager];
        [skModel.skController makePurchaseForProductID:skModel.productSubscribeID  AndReturnTo:nil];
    }
}

-(void) checkForExpiredAndExpiringSubscription
{
     UserModel *userModel = [UserModel userModel];
    
    BOOL isExpiring = [userModel.userSettings isSubscriptionRunningOut];
    BOOL isExpired =  [userModel.userSettings isSubscriptionExpired];
    
    if (isExpiring)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *dateString = [dateFormatter stringFromDate:userModel.userSettings.subscriberUntilDate];
        
        // show expiring warning
        NSString *question = 
        [NSString stringWithFormat:@"Your unlimited subscription will be expiring on %@.  Do you want to renew now?", dateString];
        
        [self showRenewAlertWithQuestion:question];
    }
    
    if (isExpired)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *dateString = [dateFormatter stringFromDate:userModel.userSettings.subscriberUntilDate];
        
        // show expired warning
        NSString *question = 
        [NSString stringWithFormat:@"Your unlimited subscription expired on %@.  Do you want to renew now?",dateString];
        
        [self showRenewAlertWithQuestion:question];
    }
}

-(void) userLoggedIn
{
    
    UserModel *userModel = [UserModel userModel];
    
    if (!isAppearingFromBackground)
    {
        [rootViewController.view removeFromSuperview];
    
        [userModel saveUserSettings];
	  
        [self showScreen];
    }
    else
    {
        [clockViewController refreshWeather];
        [clockViewController refreshUnreadMessages];
    }
    
    
    
    [self checkForExpiredAndExpiringSubscription];  
}



-(void)showScreen {
	// makes the window visible
	
	// set the xib
	//if ([userModel.userSettings.themeName isEqualToString:@"High Contrast"])
	//{
	//	clockViewController = [[ClockViewController alloc] initWithNibName:@"HighContrastClock" bundle:nil];               // creates your table view - this should be a UIViewController with a table view in it, or UITableViewController
	//}
	//else {
		               // creates your table view - this should be a UIViewController with a table view in it, or UITableViewController
	//}
	//[window addSubview:clockViewController.view];
    
    [loginViewController.view removeFromSuperview];
    
   if(  [rootViewController respondsToSelector:@selector(view)] )
   {
        [rootViewController.view removeFromSuperview];
   }
  
    
    clockViewController = [[ClockViewController alloc] initWithNibName:@"Clock" bundle:nil]; 
    self.window.rootViewController = self.clockViewController;
    
    [window makeKeyAndVisible];
    
    
}

-(void)applicationDidEnterBackground:(UIApplication *)application 
{
    isAppearingFromBackground = YES;
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	[sharedManager saveAlarms];
	
	ClockModel *clockModel = [ClockModel clockModel];
	[clockModel stopClock];
}

- (void)applicationDidEnterForeground:(UIApplication *)application 
{
    /*
     Called as part of  transition from the background to the inactive state:
     /here you can undo many of the changes made on entering the background.
     */
    NSLog(@"applicationWillEnterForeground");
    
    UserModel *userModel = [UserModel userModel];
    
    
    if (!isFromReturnFromFacebookApp)
    {
    // log in to bed Buzz Server
    LoginService *loginService = [[LoginService alloc] init];
    [loginService logOnUserWithBedBuzzID:userModel.userSettings.bedBuzzID andFBID:userModel.userSettings.fbID  AndReturnTo:self];
    
    }
    
    if (isFromReturnFromFacebookApp)
    {
        isFromReturnFromFacebookApp=NO;
        [self showScreen];
        
    }
}



-(void)applicationDidBecomeActive:(UIApplication *)application
{
    
    NSLog(@"applicationDidBecomeActive");
    
   // [self checkForExpiredAndExpiringSubscription];
    UserModel *userModel = [UserModel userModel];

    
    WeatherModel *wm = [WeatherModel weatherModel];
    if (wm.weatherConditions!=nil && wm.weatherConditions.count > 0)
    {
        [wm refreshWeatherAndReturnTo:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application 
{
    NSLog(@"applicationWillTerminate");
    
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	[sharedManager saveAlarms];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification 
{ 
	
	NSLog(@"didReceiveLocalNotification");
	
    if (application.applicationState == UIApplicationStateActive) { 
        NSLog(@"dont do anything"); 
    }  
	else {
        isFromNotification = YES;
        // first we need to get the weather
        alarmShouldPlay = YES;
        NSDictionary *alarmData = notification.userInfo;
		alarmNameToPlay = [alarmData objectForKey:@"alarmName"];
        
        // clock model will pick up that we should play an alarm
        [self setUp:YES];
	}

	
}  

-(void)weatherWasUpdated {
    [clockViewController weatherWasUpdated];
    
   
}

-(void)loadAlarms {

	
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	
	// DEBUG  - clear alarms below
	//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAlarms"];
	
	
	
	NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"kAlarms"];
	NSArray *oldSavedArray;
	BOOL alarmsRetreived = NO;
	
	if (dataRepresentingSavedArray != nil)
	{
	
		@try { // we get a sig fault if we saved incorrectly
			alarmsRetreived = YES;
			oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
		}
		@catch (NSException *exception) {
			NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
		}
		
        
	}
	
	if (alarmsRetreived)
		[sharedManager setAlarms:[[NSMutableArray alloc] initWithArray:oldSavedArray]];
	else
		[sharedManager setAlarms:[[NSMutableArray alloc] init]];
}



                                           // lets go of everything else, thats so your program doesn't create any leaks of memory.



@end
