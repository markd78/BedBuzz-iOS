//
//  AlarmGoingOffViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmGoingOffViewController.h"
#import "SoundDirector.h"
#import "ClockModel.h"
#import "WeatherModel.h"
#import "UserModel.h"
#import "FetchMessagesService.h"
#import "FetchRSSClipsService.h"
#import "RSSModel.h"
#import "RSSFeed.h"
#import "SpeakAlarmAppDelegate.h"
#import "Flurry.h"
#import "MessageViewViewController.h"
#import "UIWebView+Clean.h"

@implementation AlarmGoingOffViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		[self runTimer];
		
        // do not let go to sleep while in alarming mode
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
		UserModel *userModel = [UserModel userModel];
		mService = [[FetchMessagesService alloc] init];
		[mService fetchUnreadMessages:userModel.userSettings.fbID ThatAreOlderThanOneDay:NO AndReturnTo:self];
		
        if (userModel.userSettings.isPaidUser)
        {
            RSSModel *rssModel = [RSSModel sharedManager];
		
            rssService = [[FetchRSSClipsService alloc] init];
		
            for (RSSFeed *feed in rssModel.rssFeeds)
            {
			
                [rssService getRSSClips:feed.feedLink withVoiceName:feed.voiceName AndReturnTo:self];
            }
        }
		
        userModel.userSettings.numberOfAlarmsHappened++;
        [userModel saveUserSettings];
		
		WeatherModel *weatherModel = [WeatherModel weatherModel];
		[weatherModel parseWeatherJSONFile];
		[weatherModel refreshWeatherAndReturnTo:self];
		
    }
    return self;
}


-(void)weatherWasUpdated {
	
	
	WeatherModel *weatherModel = [WeatherModel weatherModel];
	
	
	UserModel *userModel = [UserModel userModel];
	NSString *tempStr ;
	if (userModel.userSettings.isCelcius)
	{
		tempStr = [NSString stringWithFormat:@"%d", weatherModel.weatherNow.currentTempC];
		[weatherTempUnitLbl setText:@"°C"];
	}
	else {
		tempStr = [NSString stringWithFormat:@"%d", weatherModel.weatherNow.currentTempF];
		[weatherTempUnitLbl setText:@"°F"];
	}
	
	[weatherTempLbl setText:tempStr];
	
	
	NSString *weatherImageFile;
	if ([weatherModel isDark] == NO)
	{
		weatherImageFile = [NSString stringWithFormat:@"%@%@", weatherModel.weatherNow.condition.dayIcon, @".png"];
	}
	else {
		weatherImageFile = [NSString stringWithFormat:@"%@%@", weatherModel.weatherNow.condition.nightIcon, @".png"];
	}
	
	UIImage *weatherImage = [UIImage imageNamed:weatherImageFile];
	[weatherImageView setImage:weatherImage];
	
    //SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
    
   // [appDelegate weatherWasUpdated];
}


-(void)doArrowAnimation
{
    arrowImageView.frame = originalArrowFrame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    CGRect movingToFrame = arrowImageView.frame;
    movingToFrame.origin.x = arrowImageView.frame.origin.x + sleepySlider.frame.size.width-30;
    
    arrowImageView.alpha = 1.0;
    arrowImageView.frame = movingToFrame;
    
    [UIView commitAnimations];
}

-(void)animateArrow
{
    animateArrowTimer = [NSTimer scheduledTimerWithTimeInterval:2
                                                         target:self
                                                       selector:@selector(doArrowAnimation)
                                                       userInfo:nil
                                                        repeats:YES];
}

-(void) alarmIsGoingOff;
{
	snoozeButton.enabled = true;
	snoozeButton.alpha = 1.0;
    
    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self weatherWasUpdated];
    
    [Flurry  logEvent:@"alarm going off"];
	
    //if ios5 - set brightness 
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
    {
        [[UIScreen mainScreen] setBrightness:1];
    }
        
	rssWebView.hidden = YES;
	rssWebViewCloseBtn.hidden = YES;
    
    originalArrowFrame = arrowImageView.frame;
    
    [self animateArrow];
}


- (void)runTimer {
	// This starts the timer which fires the showActivity
	// method every 0.5 seconds
	myTicker = [NSTimer scheduledTimerWithTimeInterval: 0.5
												target: self
											  selector: @selector(showActivity)
											  userInfo: nil
											   repeats: YES];
	
}

// This method is run every 0.5 seconds by the timer created
// in the function runTimer
- (void)showActivity {
	NSDateFormatter *formatter =
	[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
	
    // This will produce a time that looks like "12:15:00 PM".
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
	
	// This sets the label with the updated time.
	[clockLabel setText:[formatter stringFromDate:date]];
    
}

-(void)showRefreshingWeatherSpinner {
	weatherTempUnitLbl.hidden = YES;
	weatherTempLbl.hidden = YES;
	weatherImageView.hidden = YES;
}

-(void)hideRefreshingWeatherSpinner {
	weatherTempUnitLbl.hidden = NO;
	weatherTempLbl.hidden = NO;
	weatherImageView.hidden = NO;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return YES;
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
    [animateArrowTimer invalidate];
    animateArrowTimer = nil;
}




- (IBAction)snoozeClicked:(id)sender
{
	// send message to sound director
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector snoozeClicked];
	
	ClockModel *clockModel = [ClockModel clockModel];
	[clockModel setSnoozeForCurrentAlarm];
	
	snoozeButton.enabled = false;
	snoozeButton.alpha = 0.3;
	[clockModel letMeKnowWhenAlarmPlaysAfterSnooze:self];
}

- (IBAction)sleepySliderValueChanged:(id)sender
{
	if (sleepySlider.value == 1)
	{
		ClockModel *clockModel = [ClockModel clockModel];
		clockModel.isAlarmPlaying = false;
		clockModel.isAlarmShowing = false;
        // we will check this flag while deciding what pop up to show
        clockModel.didAlarmJustPlay = true;
        
		UserModel *userModel = [UserModel userModel];
		[UIApplication sharedApplication].idleTimerDisabled = userModel.userSettings.isKeepAwakeOn;
        
		// send message to cancel alarm
		SoundDirector *soundDirector = [SoundDirector soundDirector];
		[soundDirector stopAlarm];
        
        // if the user has missed some messages, should play them now
        [soundDirector addMessagesAndAdsToPlayQueueAndPlay];
        
        [clockModel forgetSnooze];
		
        SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate showAds];
        
        RSSModel *rssModel = [RSSModel sharedManager];
        [rssModel.rssClips removeAllObjects];
       // [rssModel.rssFeeds removeAllObjects];
        
        if (rssModel.webviewDict!=nil)
        {
            rssModel.webviewDict;
        }
        
        // this is to refresh the weather (sunrise might have happened since the alarm initially sounded)
        
        [appDelegate weatherWasUpdated];
        
        if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [appDelegate alarmFinished ];
        }
        else
        {
            [self.view removeFromSuperview];
        }
		
        [appDelegate showSubscribeWizard];
	}
}

- (IBAction)closeRSSButtonClicked:(id)sender
{
    webView.hidden = YES;
    rssWebViewCloseBtn.hidden = YES;
    
    // stop playing the news
    SoundDirector *soundDirector = [SoundDirector soundDirector];
    [soundDirector stopPlayingRSS];
}




-(void) messagesHaveBeenFetched
{
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector addMessagesToPlayQueueAndLetMeKnowWhenTheyAreBeingPlayed:self];
    
}

-(void)messageIsBeingPlayed:(MessageVO *)message
{
    messageViewController = [[MessageViewViewController alloc] initWithNibName:@"MessageView" bundle:nil withMessage:message];
    
    
    
    [self.view addSubview:messageViewController.view];
    
    
    // start off screen
    [messageViewController.view setFrame:CGRectMake(0+self.view.frame.size.width, messageViewController.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    // move on screen
    
    [messageViewController.view setFrame:CGRectMake(0, messageViewController.view.frame.origin.y, messageViewController.view.frame.size.width, messageViewController.view.frame.size.height)];
    
    [UIView commitAnimations];
}   

-(void)messageFinishedPlaying
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    
    // animate the message view out
     [messageViewController.view setFrame:CGRectMake(0 - messageViewController.view.frame.size.width, messageViewController.view.frame.origin.y, messageViewController.view.frame.size.width, messageViewController.view.frame.size.height)];
    
     [UIView commitAnimations];
    
    
}

-(void)fetchWebViewsForRSSClips
{
    RSSModel *rssModel = [RSSModel sharedManager];
    rssModel.webviewDict = [[NSMutableDictionary alloc] init];
    for (RSSClip *clip in rssModel.rssClips)
    {
        UIWebView *webViewForClip = [[UIWebView alloc] init];
        webViewForClip.scalesPageToFit = YES;
        webViewForClip.hidden = YES;
        [webViewForClip setFrame:rssWebView.frame];
        
        @try {
            //Create a URL object.
            NSURL *url = [NSURL URLWithString:clip.link];
        
            //URL Requst Object
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
            //Load the request in the UIWebView.
            [webViewForClip loadRequest:requestObj];
            
            [rssModel storeWebView:webViewForClip ForURL:clip.link];
        
        }
        @catch (NSException * e) {
            // fail silently just dont set the web view
            NSLog(@"Exception: %@", e);
        }
    }
}

-(void) rssClipsHaveBeenFetched
{
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector addRSSClipsToPlayQueueAndLetMeKnowWhenTheyAreBeingPlayed:self];
    
    
    // now pre fetch the webviews for each url
    [self fetchWebViewsForRSSClips];
    
}



-(void) rssClipsFetchingError
{
    
}

-(void)RSSClipBeingPlayed:(NSString *) urlStr;
{
    
      RSSModel *rssModel = [RSSModel sharedManager];

	webView = [rssModel.webviewDict objectForKey:urlStr];
    [self.view addSubview:webView];
    [webView setFrame:CGRectMake(0+self.view.frame.size.width, rssWebView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    
    webView.hidden = NO;
       
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [webView setFrame: CGRectMake(0, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height)];
    
    [UIView commitAnimations];
    
    
  //  rssWebView = webViewToShow;
    
   // 
      
       rssWebViewCloseBtn.hidden = NO;
	[self.view bringSubviewToFront:rssWebViewCloseBtn];
}

-(void)RSSClipEnded
{
    rssWebViewCloseBtn.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [webView setFrame:CGRectMake(0-webView.frame.size.width, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height)];
    
    [UIView commitAnimations];
    
    [webView cleanForDealloc];
    webView = nil;
}

@end
