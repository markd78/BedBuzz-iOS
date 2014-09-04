//
//  Clock.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClockViewController.h"
#import "SettingsViewController.h"
#import "AlarmsModel.h"
#import "WeatherModel.h"
#import "SoundDirector.h"
#import "ClockModel.h"
#import "UserModel.h"
#import "SpeakAlarmAppDelegate.h"
#import "SelectFriendsForMessageViewController.h"
#import "FacebookModel.h"
#import "iToast.h"
#import "MessagingModel.h"
#import "FetchMessagesService.h"
#import "Reachability.h"
#import "SelectFriendsForMessageViewController.h"
#import "HelpScreenViewController.h"
#import "SendMessageWizardViewController.h"
#import "ViewHelper.h"
#import "PleaseReviewController.h"
#import "Welcome3EnableFacebookViewController.h"
#import  "RedirectingToFacebookViewController.h"
#import "ChangeVoiceQuestionViewController.h"
#import "Utilities.h"
#import "SubscribeQuestionViewController.h"

@implementation ClockViewController
@synthesize weatherTempLbl;
@synthesize weatherTempUnitLbl;
@synthesize weatherImageView;
@synthesize dateLabel;
@synthesize backgroundImageView;
@synthesize currentThemeType;
@synthesize infoButton;
@synthesize ampmLbl;
@synthesize facebookButton;
@synthesize mService;
@synthesize settingsPopoverController;
@synthesize messagingPopoverController;
@synthesize settingsViewController;
@synthesize settingsBtn;
@synthesize helper;
@synthesize redirectScreen;
@synthesize welcome3;
@synthesize subscribeWizard;
@synthesize changeVoiceWizard;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        justLoggedInToFacebook = NO;
        fromAppLoad = YES;
        iPadAdBannerVisible = NO;
        isWeatherMovedDown = NO;
        adBannerView.delegate = self;
    }
    
    
    return self;
}

-(void)refreshCurrentWidthHeight
{
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            currentWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
            currentHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            currentWidth = CGRectGetHeight([[UIScreen mainScreen] bounds]);
            currentHeight =CGRectGetWidth([[UIScreen mainScreen] bounds]);
            break;
        default:
            currentWidth = CGRectGetWidth(self.view.bounds);
            currentHeight = CGRectGetHeight(self.view.bounds);
    }
}

- (void)showAdBannerForiPad {
    UserModel *userModel = [UserModel userModel];
    if (!userModel.userSettings.isPaidUser && !userModel.userSettings.isOfflineMode)
    {
        adBannerView.hidden = NO;
        iPadAdBannerVisible = YES;
        
        // after 8 mins, hide the ads
        [NSTimer scheduledTimerWithTimeInterval:480.0f
                                         target:self
                                       selector:@selector(hideAdsAfterTimer:)
                                       userInfo:nil
                                        repeats:NO];
    }
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    UserModel *userModel = [UserModel userModel];
    if (iPadAdBannerVisible && !userModel.userSettings.isPaidUser )
    {
        adBannerView.hidden = NO;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (iPadAdBannerVisible)
    {
        adBannerView.hidden = YES;
    }
}

-(IBAction) showSettingInPopup:(id) sender {
    settingsBtn = sender;
    [self showSettingsforIPad:none];
    
}

-(void)showSettingsforIPad:(WizardScreen)fromWizardScreen
{
    if (self.settingsPopoverController == nil) {
        
        fromAppLoad = NO;
        
        [self hideAds];
        
        SettingsViewController *settingsView = [[SettingsViewController alloc] initWithNibName:@"Settings" bundle:[NSBundle mainBundle]];
        
        settingsView.navigationItem.title = @"Settings";
        UINavigationController *navController = 
        [[UINavigationController alloc] 
         initWithRootViewController:settingsView];
        
        UIPopoverController *popover = 
        [[UIPopoverController alloc] initWithContentViewController:navController]; 
        
        
        self.settingsViewController = settingsView;
        
       
        
        popover.delegate = self;
        
        self.settingsPopoverController = popover;
    }
    
    CGRect popoverRect = [self.view convertRect:[settingsBtn frame] 
                                       fromView:[settingsBtn superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100); 
    [self.settingsPopoverController 
     presentPopoverFromRect:popoverRect 
     inView:self.view 
     permittedArrowDirections:UIPopoverArrowDirectionAny 
     animated:YES];   
    
    if (fromWizardScreen == changeVoiceScreen)
    {
        // automatically show the settings screen
        // voices
        self.settingsViewController.voiceSettingsViewController = [[VoiceSettingsViewController alloc] initWithNibName:@"VoicesSettings" bundle:[NSBundle mainBundle]];
        [self.settingsViewController.navigationController pushViewController:self.settingsViewController.voiceSettingsViewController animated:YES];
    }
    else if (fromWizardScreen == subscribeScreen)
    {
        [self.settingsViewController subscribeBtnPressed];
    }
}

-(void)showPleaseReview
{
    UserModel *userModel = [UserModel userModel];
    
    SoundDirector *sd = [SoundDirector soundDirector];
    [sd playPleaseReview];
    
    ViewHelper *vh = [ViewHelper sharedManager];
    PleaseReviewController *wizard = [[PleaseReviewController alloc] initWithNibName:@"PleaseReview" bundle:nil AndReturnTo:self];
    currentWizardView =  wizard.view;
    
    wizard.view = [vh formatTheViewForDarkWizard:wizard.view];
    
    [self.view addSubview:wizard.view];
    [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    userModel.userSettings.haveShownReviewRequest = YES;
    [userModel saveUserSettings];
}

//---called when the user clicks outside the popover view---
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    
    // reset the target friends
    MessagingModel *messagingModel = [MessagingModel sharedManager];
    [messagingModel.targetFriends removeAllObjects];
    
    UINavigationController *navController = (UINavigationController*)self.messagingPopoverController.contentViewController;
    
    [navController popToRootViewControllerAnimated:NO];
    
    UINavigationController *navControllerSettings = (UINavigationController*)self.settingsPopoverController.contentViewController;
    
    [navControllerSettings popToRootViewControllerAnimated:NO];
    
    NSLog(@"popover about to be dismissed");
    [self showAdBannerForiPad];
    
    [self showPopupIfNeeded];
    
    // refresh facebook button (might have hidden it)
    UserModel *userModel = [UserModel userModel];
    [facebookButton setHidden:userModel.userSettings.hideFacebookBtn];
    
    if (userModel.userSettings.showTitleBar)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        // self.navigationController.navigationBar.frame = CGRectOffset(self.//navigationController.navigationBar.frame, 0.0, -20.0);
        
        self.view.frame = [[UIScreen mainScreen] bounds];
      //  self.backgroundImageView.frame = [[UIScreen mainScreen] bounds];
    }
    
    [self refreshCurrentWidthHeight];
    [self.backgroundImageView setFrame:CGRectMake(0, 0, currentWidth, currentHeight)];
    
    WeatherModel *wm = [WeatherModel weatherModel];
    [wm refreshWeatherAndReturnTo:self];
    
    return YES;
}

//---called when the popover view is dismissed---
- (void)popoverControllerDidDismissPopover:
(UIPopoverController *)popoverController {
    
    NSLog(@"popover dismissed");    
    
}

- (NSString *)adWhirlApplicationKey {
    return @"233d7a1b1a8a48e2947cbb674a3eea65";
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self; //UIWindow.rootViewController;
}

-(void)gotFacebookFriends {
    facebookButton.enabled  = YES;
    [self hideRefreshingFriendsSpinner];
    
    UserModel *userModel = [UserModel userModel];
    if (!userModel.userSettings.heardComposeMessageHelp)
    {
        [self showSendMessageQuestion];
        userModel.userSettings.popupMessageCount =1;
        [userModel saveUserSettings];
    }
    
}

-(void)refreshControlsAfterOfflineCheck
{
    UserModel *userModel = [UserModel userModel];
    if (!userModel.userSettings.isOfflineMode)
    {
        facebookButton.hidden = userModel.userSettings.hideFacebookBtn;
        [self hideRefreshingFriendsSpinner];
        weatherImageView.hidden = NO;
        weatherTempLbl.hidden = NO;
        weatherTempUnitLbl.hidden = NO;
        FacebookModel *model = [FacebookModel sharedManager];
        
        if (userModel.userSettings.fbID != nil  && [userModel.userSettings.fbID intValue]!=-1 && model.friendsList==nil)
        {
            [self showRefreshingFriendsSpinner];
            
            [model getFacebookFriendsAndReturnTo:self];
        }
        
        WeatherModel *weatherModel = [WeatherModel weatherModel];
        if (weatherModel.weatherNow == nil)
        {
            [weatherModel refreshWeatherAndReturnTo:self];
        }
	}
    else
    {
        facebookButton.hidden = YES;
        [self hideRefreshingFriendsSpinner];
        weatherTempUnitLbl.hidden = YES;
        weatherTempLbl.hidden = YES;
        weatherImageView.hidden = YES;
        [refreshWeatherSpinner stopAnimating];
        refreshWeatherSpinner.hidden = YES;
    }
    
}

-(void)initiateOfflineCheck
{
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateInterfaceWithReachability: internetReach];
}

//Called by Reachability whenever status changes.
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == internetReach)
	{	
        UserModel *userModel = [UserModel userModel];
        
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        switch (netStatus)
        {
            case NotReachable:
            {
                userModel.userSettings.isOfflineMode = YES;
                break;
            }
            default:
            {
                userModel.userSettings.isOfflineMode = NO;
            }
        }
    }
    
    [self refreshControlsAfterOfflineCheck];
}

-(void)refreshWeather
{
    WeatherModel *weatherModel = [WeatherModel weatherModel];
    [weatherModel parseWeatherJSONFile];
    [weatherModel refreshWeatherAndReturnTo:self];
    
    [self showRefreshingWeatherSpinner];
}

-(void)moveDateAndWeatherDownIfPaid
{
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser && !isWeatherMovedDown)
    {
        isWeatherMovedDown = YES;
        weatherView.frame = CGRectMake(weatherView.frame.origin.x, weatherView.frame.origin.y+50, weatherView.frame.size.width, weatherView.frame.size.height);
        dateLabel.frame = CGRectMake(dateLabel.frame.origin.x, dateLabel.frame.origin.y+50, dateLabel.frame.size.width, dateLabel.frame.size.height);
    }
}

-(void)hideTapForTapAdsIfNeeded
{
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser && adBannerView!=nil)
    {
         [adBannerView setHidden:YES];   
    }
}

-(void)repositionTapForTapAds
{
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser)
    {
        return;
    }
    
    if (adBannerView == nil)
    {
        return;
    }
    
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect cgRect  =[[UIScreen mainScreen] bounds];
    
    
    CGSize screenSize = cgRect.size;
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            adBannerView.frame = CGRectMake(0, screenSize.height - 50 - statusBarRect.size.height, 320, 50);
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            adBannerView.frame = CGRectMake(screenSize.height / 2 - 160 , screenSize.width - 50- statusBarRect.size.width, 320, 50);
            break;
        default:
            adBannerView.frame = CGRectMake(screenSize.height / 2 - 160 , screenSize.width - 50- statusBarRect.size.width, 320, 50);
    }
    
}

-(void)showTapForTapAds
{
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser)
    {
        return;
    }
    
    //  CGRect cgRect =[[UIScreen mainScreen] bounds];
    CGRect cgRect =[[UIScreen mainScreen] applicationFrame];
    CGSize screenSize = cgRect.size;
    
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            adBannerView = [[ADBannerView alloc] initWithFrame: CGRectMake(0, screenSize.height - 50, 320, 50)];
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            adBannerView = [[ADBannerView alloc] initWithFrame: CGRectMake(screenSize.height / 2 - 160 , screenSize.width - 50, 320, 50)];
            break;
        default:
            adBannerView = [[ADBannerView alloc] initWithFrame: CGRectMake(screenSize.height / 2 - 160 , screenSize.width - 50, 320, 50)];
    }
    
    
    [self.view addSubview: adBannerView];
    
    // If you do not use ARC then release the adBannerView.
    //[adBannerView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *userModel = [UserModel userModel];
    
    if((void *)UI_USER_INTERFACE_IDIOM() == NULL ||
       UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self moveDateAndWeatherDownIfPaid];
    }
    
     [self refreshCurrentWidthHeight];
    
    // show help screen ?
    if (!userModel.userSettings.haveShownHelpScreen)
    {
        
        helper = [[HelpScreenViewController alloc] initWithNibName:@"HelperScreen" bundle:nil andReturnTo:self ];
        [helper.view setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.3]];
        [helper.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        SoundDirector *soundDirector = [SoundDirector soundDirector];
        [soundDirector sayWelcome];
        [self.view addSubview:helper.view];
    }
    
    [facebookButton setHidden:userModel.userSettings.hideFacebookBtn];
    
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOrHidePowerButton)
                                                 name:UIDeviceBatteryStateDidChangeNotification object:nil];
    messageSentLbl.hidden = YES;
	facebookButton.enabled  = NO;
	isShowingAds = NO;
    
    ClockModel *clockModel = [ClockModel clockModel];
    [self registerForAlarmGoingOff];
    [clockModel startClock];
    
	// This calls the runTimer method after loading
	[self runTimer];
    [self runWeatherTimer];
    
   	
	// do an offline check
    [self initiateOfflineCheck];
	
    
    [self refreshWeather];
    
	self.currentThemeType = userModel.userSettings.themeName;
    
    
	
    if (userModel.userSettings.fbID != nil  && [userModel.userSettings.fbID intValue]!=-1 && !userModel.userSettings.isOfflineMode)
    {
        [self showRefreshingFriendsSpinner];
        FacebookModel *model = [FacebookModel sharedManager];
        [model getFacebookFriendsAndReturnTo:self];
    }
    else
    {
        refreshFriendsSpinner.hidden = YES;
    }
    
    // check if the user has unread messages
    messagesButton.hidden = YES;
    [self refreshUnreadMessages];
    
    [self showOrHidePowerButton];
    
   
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // hide the ads initially until an ad is loaded
        iPadAdBannerVisible = YES;
        adBannerView.hidden = YES;
    }
    else
    {
        [self showTapForTapAds];
    }
    
    
}

-(void)showSendMessageQuestion
{
    // if there is already a wizard showing, do not show another over the top of it
    if (currentWizardView!=nil)
    {
        return;
    }

    
    SoundDirector *soundDirector = [SoundDirector soundDirector];
    [soundDirector stopSounds];
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.fbID!=nil && [userModel.userSettings.fbID intValue]!=-1)
    {
        [soundDirector saySendMessageQuestion];
        
        
        ViewHelper *vh = [ViewHelper sharedManager];
        SendMessageWizardViewController *wizard = [[SendMessageWizardViewController alloc] initWithNibName:@"Welcome4SendMessage" bundle:nil AndReturnTo:self];
        currentWizardView =  wizard.view;
        
        wizard.view = [vh formatTheViewForDarkWizard:wizard.view];
        
        [self.view addSubview:wizard.view];
        [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
}

-(void)showChangeVoiceQuestion
{
    SoundDirector *soundDirector = [SoundDirector soundDirector];
    [soundDirector stopSounds];
    
    [soundDirector sayChangeVoiceQuestion];
    
    
    ViewHelper *vh = [ViewHelper sharedManager];
    changeVoiceWizard = [[ChangeVoiceQuestionViewController alloc] initWithNibName:@"ChangeVoiceQuestion" bundle:nil AndReturnTo:self];
    currentWizardView =  changeVoiceWizard.view;
    
    changeVoiceWizard.view = [vh formatTheViewForDarkWizard:changeVoiceWizard.view];
    
    [self.view addSubview:changeVoiceWizard.view];
    [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    
}

-(void)showSubscribeQuestion:(BOOL)withSound
{
    if (withSound)
    {
        SoundDirector *soundDirector = [SoundDirector soundDirector];
        [soundDirector stopSounds];
    
        [soundDirector saySubscribeQuestion];
    }
    
    ViewHelper *vh = [ViewHelper sharedManager];
    subscribeWizard = [[SubscribeQuestionViewController alloc] initWithNibName:@"SubscribeQuestion" bundle:nil AndReturnTo:self];
    currentWizardView =  subscribeWizard.view;
    
    subscribeWizard.view = [vh formatTheViewForDarkWizard:subscribeWizard.view];
    
    [self.view addSubview:subscribeWizard.view];
    [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
    
}

-(void)showPopupIfNeeded
{
    // if there is already a wizard showing, do not show another over the top of it
    if (currentWizardView!=nil)
    {
        return;
    }
    
    UserModel *um = [UserModel userModel];
    ClockModel *clockModel = [ClockModel clockModel];
    
    if (clockModel.didAlarmJustPlay)
    {
        // already shown from the app delegate
        //[self showSubscribeQuestion:FALSE];
        clockModel.didAlarmJustPlay = NO;
    }
    else {
        // only show popup if user has been past the help screen
        if (um.userSettings.haveShownHelpScreen)
        {
            if (!um.userSettings.haveShownReviewRequest && um.userSettings.numberOfAlarmsHappened >= 2 )
            {
                // review
                [self showPleaseReview];
            }
            else if (um.userSettings.popupMessageCount % 7 == 0 && [um.userSettings.fbID longValue] > 0 && !um.userSettings.isPaidUser)
            { // if 'send message' question not shown, then show it
                
                // send message?
                [self showSendMessageQuestion];
            }
            else if (um.userSettings.popupMessageCount % 7 <= 1 && !um.userSettings.isPaidUser && !um.userSettings.userHasChangedVoice)
            {
                // in case we skipped previous.. incr the counter
                if (um.userSettings.popupMessageCount % 7 == 0)
                {
                    um.userSettings.popupMessageCount++;
                }
                
                // change voice?
                [self showChangeVoiceQuestion];
            }
            else if (um.userSettings.popupMessageCount  % 7 == 4 && !um.userSettings.isPaidUser)
            {
                // subscribe?
                [self showSubscribeQuestion:TRUE];
            }
            
            um.userSettings.popupMessageCount++;
            [um saveUserSettings];
        }
    }
}

-(void)helpScreenClosed
{
    // show send message screen
    [self.helper.view removeFromSuperview];
    
    UserModel *userModel = [UserModel userModel];
    userModel.userSettings.haveShownHelpScreen = YES;
    userModel.userSettings.popupMessageCount = 0;
    
    [userModel saveUserSettings];
    
    [self showPopupIfNeeded];
    
}


-(void)showNextScreen:(int)screen FromCurrentScreen:(int)currentScreen
{
    
    ViewHelper *vh = [ViewHelper sharedManager];
    
    if (screen == messagingScreen)
    {
        [self showMessaging:facebookButton];
         currentWizardView = nil;
    }
    else if (screen == redirectingToFacebook)
    {
        self.redirectScreen = [[RedirectingToFacebookViewController alloc] initWithNibName:@"RedirectingTofacebook" bundle:nil AndReturnTo:self];
        currentWizardView =  redirectScreen.view;
        
        redirectScreen.view = [vh formatTheViewForDarkWizard:redirectScreen.view];
        
        [self.view addSubview:redirectScreen.view];
        [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
    else if (screen == changeVoiceScreen)
    {
        [self showChangeVoiceScreen];
    }
    else if (screen == subscribeScreen)
    {
        [self showSubscribeScreen];
    }
    else {
        currentWizardView = nil;
    }
}

-(void)registerForAlarmGoingOff 
{
    // register to listen for when to show 'alarm going off' screen
	ClockModel *clockModel =[ClockModel clockModel];
	[clockModel registerForAlarmGoingOff:self];
}



/*-(void)showAds {
 
 if((void *)UI_USER_INTERFACE_IDIOM() == NULL ||
 UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) 
 {
 UserModel *userModel = [UserModel userModel]; 
 
 if (userModel.userSettings.isPaidUser)
 {
 return;
 }
 
 isShowingAds = NO;
 adWhirlView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
 
 CGRect cgRect =[[UIScreen mainScreen] bounds];
 CGSize cgSize = cgRect.size;
 
 
 
 adWhirlView.frame =  CGRectMake(0, cgSize.height -50, cgSize.width, 50);
 
 [self.view addSubview:adWhirlView]; 
 
 // after 2 mins, hide the ads
 [NSTimer scheduledTimerWithTimeInterval:120.0f
 target:self
 selector:@selector(hideAdsAfterTimer:)
 userInfo:nil
 repeats:NO];
 }
 }*/

-(void)hideAdsAfterTimer:(NSTimer*)timer
{
    iPadAdBannerVisible = NO;
    
    [self hideAds];
}

-(void)hideAds {
    
    if (adBannerView!=nil)
    {
        adBannerView.hidden = YES;
    }
    
}

-(void)showRefreshingFriendsSpinner {
	refreshFriendsSpinner.hidden = NO;
	[refreshFriendsSpinner startAnimating];
    facebookButton.enabled = NO;
}

-(void)hideRefreshingFriendsSpinner {
    [refreshFriendsSpinner stopAnimating];
    refreshFriendsSpinner.hidden = YES;
    facebookButton.enabled = YES;
}

-(void)showRefreshingWeatherSpinner {
	weatherTempUnitLbl.hidden = YES;
	weatherTempLbl.hidden = YES;
	weatherImageView.hidden = YES;
	refreshWeatherSpinner.hidden = NO;
	[refreshWeatherSpinner startAnimating];
}

-(void)hideRefreshingWeatherSpinner {
	weatherTempUnitLbl.hidden = NO;
	weatherTempLbl.hidden = NO;
	weatherImageView.hidden = NO;
	[refreshWeatherSpinner stopAnimating];
	refreshWeatherSpinner.hidden = YES;
}

-(void)drawScreen {
	/* this function repositions the controls based on the current themee style */
  //  double newStartX = (self.view.frame.size.width) /2 - (clockLabel.frame.size.width /2);
  //  double newStartX = clockLabel.frame.origin.x;
	//clockLabel.frame = CGRectMake( newStartX,clockLabel.frame.origin.y,clockLabel.frame.size.width,clockLabel.frame.size.height);
    
    
	UserModel *userModel = [UserModel userModel];
    
    if (userModel.userSettings.showTitleBar)
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    else {
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
	
    // if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
    //    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
    dateLabel.clipsToBounds = NO;
    
    if ([userModel.userSettings.themeName isEqualToString:@"High Contrast"])
    {
        self.view.backgroundColor = [UIColor blackColor];
        [clockLabel setTextColor:[UIColor greenColor]];
        if((void *)UI_USER_INTERFACE_IDIOM() == NULL||
           UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [clockLabel setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:150.0f]];
            [ampmLbl setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:25.0f]];
        }
        else {
            [clockLabel setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:350.0f]];
            [ampmLbl setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:120.0f]];
        }
        [dateLabel  setTextColor:[UIColor greenColor]];
        [weatherTempLbl setTextColor:[UIColor greenColor]];
        [weatherTempUnitLbl  setTextColor:[UIColor greenColor]];
        [ampmLbl  setTextColor:[UIColor greenColor]];
        self.backgroundImageView.image = [UIImage imageNamed:userModel.userSettings.currentThemeImageName];
        [weatherTempLbl setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:90.0f]];
        [weatherTempUnitLbl setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:60.0f]];
        [dateLabel setFont:[UIFont fontWithName:@"LiquidCrystal-Bold" size:80]];
        
        
    }
    else
    {
        // set the image
        if (userModel.userSettings.isUserTheme)
        {
            self.backgroundImageView.image = [UIImage imageWithContentsOfFile:[Utilities GetDoucmentsPathForFile:userModel.userSettings.currentThemeImageName]];
        }
        else
        {
            self.backgroundImageView.image = [UIImage imageNamed:userModel.userSettings.currentThemeImageName];
        }
        
        [clockLabel setTextColor:[UIColor whiteColor]];
        if((void *)UI_USER_INTERFACE_IDIOM() == NULL||
           UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [clockLabel setFont:[UIFont fontWithName:@"Helvetica" size:120.0f]];
            [ampmLbl setFont:[UIFont fontWithName:@"Helvetica" size:25.0f]];
        }
        else {
            [clockLabel setFont:[UIFont fontWithName:@"Helvetica" size:230.0f]];
            [ampmLbl setFont:[UIFont fontWithName:@"Helvetica" size:35.0f]];
            
        }
        [clockLabel setTextColor:[UIColor whiteColor]];
        [ampmLbl  setTextColor:[UIColor whiteColor]];
        [dateLabel  setTextColor:[UIColor whiteColor]];
        [weatherTempLbl setFont:[UIFont fontWithName:@"Helvetica" size:90.0f]];
        [weatherTempUnitLbl setFont:[UIFont fontWithName:@"Helvetica" size:60.0f]];
        [weatherTempLbl setTextColor:[UIColor whiteColor]];
        [weatherTempUnitLbl  setTextColor:[UIColor whiteColor]];
        [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:76.0f]];
        
    }
    
    if((void *)UI_USER_INTERFACE_IDIOM() == NULL||
       UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
      //  ampmLbl.frame = CGRectMake(clockLabel.frame.origin.x + clockLabel.frame.size.width +80 ,clockLabel.frame.origin.y+50,100,100);
    }
    else {
        
        ampmLbl.frame = CGRectMake(clockLabel.bounds.origin.x + clockLabel.bounds.size.width ,clockLabel.bounds.origin.y+50,100,100);
    }
    
    [self refreshCurrentWidthHeight];
    
    [self.backgroundImageView setFrame:CGRectMake(0,0,currentWidth,currentHeight)];
        
}

-(void)repositionAdsForIpad
{
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
                
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
                break;
            default:
                adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        // close the popovers
        [self.messagingPopoverController dismissPopoverAnimated:YES];
        [self.settingsPopoverController dismissPopoverAnimated:YES];
        [self.settingsViewController.themesTableViewController.imagePopoverController dismissPopoverAnimated:NO];
        
        [self repositionAdsForIpad];
    }
    else {
        [self repositionTapForTapAds];
    }
    
    [self refreshCurrentWidthHeight];
    
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self drawScreen];
    }
    
    // move wizard to center if there is one shown
    ViewHelper *vh = [ViewHelper sharedManager];
    
    if (vh.currentViewIsInCenter)
    {
        [vh moveToStartPosition:currentWizardView ForOrientation:toInterfaceOrientation];
    }
    
}

-(void)refreshTempText {
    
    UserModel *userModel = [UserModel userModel];
    WeatherModel *weatherModel = [WeatherModel weatherModel];
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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self repositionTapForTapAds];
    
    [self showPopupIfNeeded];
    
    WeatherModel *wm = [WeatherModel weatherModel];
    [wm refreshWeatherAndReturnTo:self];
    
    
    [self refreshCurrentWidthHeight];
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.backgroundImageView.frame = CGRectMake(0, 0, currentWidth, currentHeight);
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.showTitleBar)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    
    [self repositionAdsForIpad];
    
    [self moveDateAndWeatherDownIfPaid];
    
    
	
    
    
    
    [UIApplication sharedApplication].idleTimerDisabled = userModel.userSettings.isKeepAwakeOn;
    
	
	
    
    if ([userModel.userSettings.fbID intValue]==-1)
    {
        [refreshFriendsSpinner stopAnimating];
        refreshFriendsSpinner.hidden = YES;
    }
    
	[self refreshTempText];
	
    // do an offline check
    [self initiateOfflineCheck];
    
	
    
    [self hideTapForTapAdsIfNeeded];
    
	// if we have come from settings, and change the theme, we may need to reload the correct nib
	[self drawScreen];
	
    
    
	currentThemeType = userModel.userSettings.themeName;
	
	// set the image
	if (userModel.userSettings.isUserTheme)
	{
		backgroundImageView.image =  [UIImage imageWithContentsOfFile:userModel.userSettings.currentThemeImageName];
	}
	else if (![userModel.userSettings.themeName isEqualToString:@"High Contrast"])
	{
        NSString *imageName;
        
        if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            imageName = [userModel.userSettings.currentThemeImageName stringByAppendingString:@"-ipad.jpg"];
		}
        else
        {
            imageName = [userModel.userSettings.currentThemeImageName stringByAppendingString:@".jpg"];
        }
		// strip out any spaces eg 'sunrise 2'
		imageName = [imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		// and set the image
        self.backgroundImageView.image = [UIImage imageNamed:userModel.userSettings.currentThemeImageName];
		//backgroundImageView.image =  [UIImage imageNamed:imageName];
	}
    
    //  if (!fromAppLoad)
    //  {
    // [self showAds];
    
    [self showOrHidePowerButton];
    //  }
    
    
    
    
    
}

-(void)alarmFinished
{
    [alarmGoingOffViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)alarmIsGoingOff {
    
    ClockModel *clockModel = [ClockModel clockModel];
    if (!clockModel.isAlarmShowing)
    {
        fromAppLoad = NO;
        clockModel.isAlarmShowing = YES;
        
        [self hideAds];
        
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        
        alarmGoingOffViewController = [[AlarmGoingOffViewController alloc] initWithNibName:@"AlarmGoingOff" bundle:nil];     
        [alarmGoingOffViewController.view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        //    [self.view removeFromSuperview];
        
        if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self presentModalViewController:alarmGoingOffViewController animated:YES];
        }
        else
        {
            [self.view addSubview:alarmGoingOffViewController.view];
        }
        // self.view = alarmGoingOffViewController.view;
        
        // [self.view addSubview:alarmGoingOffViewController.view];
    }                      
}

- (void)runTimer {
	// This starts the timer which fires the showActivity
	// method every 0.5 seconds***
	myTicker = [NSTimer scheduledTimerWithTimeInterval: 0.5
												target: self
											  selector: @selector(showActivity)
											  userInfo: nil
											   repeats: YES];
	
}

- (void)runWeatherTimer {
	// refresh weather every hour
	weatherTimer = [NSTimer scheduledTimerWithTimeInterval: 3600
                                                    target: self
                                                  selector: @selector(updateWeather)
                                                  userInfo: nil
                                                   repeats: YES];
	
}

-(void)updateWeather {
    WeatherModel *wm = [WeatherModel weatherModel];
    [wm refreshWeatherAndReturnTo:self];
}


// This method is run every 0.5 seconds by the timer created
// in the function runTimer
- (void)showActivity {
    
    NSDateFormatter *formatter =
	[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:date];
	NSInteger hour = [components hour];
	NSInteger minute = [components minute];
    // This will produce a time that looks like "12:15:00 PM".
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
	
	
	
	NSString *minStr;
	if (minute < 10)
	{
		minStr =  [NSString stringWithFormat:@"0%ld",(long)minute];
	}
	else {
		minStr =  [NSString stringWithFormat:@"%ld",(long)minute];
	}
    
   
    
    NSDateFormatter  *amPmFormatter = [[NSDateFormatter alloc] init];
	[amPmFormatter setDateFormat:@"aa"];
	NSString *amPMStr = 
    [amPmFormatter stringFromDate:date];
    
    
	// if amPMStr is empty, it means they have 24 hour mode on the iphone
	if ([amPMStr length] > 0)
	{
		if (hour > 12)
		{
			hour = hour - 12;
		}
	}
    
	NSString *timeStr = [NSString stringWithFormat:@"%ld:%@", (long)hour, minStr];
	
	// This sets the label with the updated time.
	[clockLabel setText:timeStr];
	[ampmLbl setText:amPMStr];
	
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	
	[dateLabel setText:[formatter stringFromDate:date]];
    
    
    
}

-(void)friendsReceived {
    facebookButton.enabled = YES;
    [self hideRefreshingFriendsSpinner];
    
    if (justLoggedInToFacebook)
    {
        [self showSettingsView:none];
        justLoggedInToFacebook = NO;
    }
}

-(void)weatherWasUpdated {
	
	[self hideRefreshingWeatherSpinner];
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
	[self.weatherImageView setImage:weatherImage];
	
}

-(void)showOrHidePowerButton
{
    if (flashPowerTimer!=nil    )
    {
        [flashPowerTimer invalidate];
        flashPowerTimer = nil;
    }
    
    UserModel *userModel = [UserModel userModel];
    if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged
        && userModel.userSettings.isKeepAwakeOn)
    {
        [self showPowerButton];
        
    }
    else
    {
        powerButton.hidden = YES;
    }
}

-(void)showPowerButton
{
    powerButton.hidden = NO;
    
    flashPowerTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                        target: self
                                                      selector: @selector(flashPower)
                                                      userInfo: nil
                                                       repeats: YES];
}

-(void)flashPower
{
    if (powerButton.alpha == 0)
    {
        powerButton.alpha = 1;
    }
    else
    {
        powerButton.alpha = 0;
    }
}


- (IBAction)powerButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The device is not plugged in, but 'Prevent sleeping' is enabled.  This could deplete your battery." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    
    powerButton.hidden = YES;
    
    [flashPowerTimer invalidate];
    flashPowerTimer = nil;
}

- (IBAction)showSettings:(id)sender {
    // AlarmSettingsViewController *settingsView = [[[AlarmSettingsViewController alloc] init] autorelease];
	
    [self showSettingsView:none];
}

-(void)showSettingsView:(WizardScreen)showFromWizardScreen {
    fromAppLoad = NO;
    
    [self hideAds];
    
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithNibName:@"Settings" bundle:nil];
	
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsView];
   	
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:navController animated:YES];
    
    if (showFromWizardScreen==changeVoiceScreen)
    {
        // automatically show the settings screen
        // voices
		settingsView.voiceSettingsViewController = [[VoiceSettingsViewController alloc] initWithNibName:@"VoicesSettings" bundle:[NSBundle mainBundle]];
		[settingsView.navigationController pushViewController:settingsView.voiceSettingsViewController animated:YES];
    }
    
    if (showFromWizardScreen==subscribeScreen)
    {
        // automatically show the settings screen
        // voices
		[settingsView subscribeBtnPressed];
    }
    
    
    
    
}

-(void)showMessagingInPopup:(id)sender {
    
    if (self.messagingPopoverController == nil) {
        SelectFriendsForMessageViewController *messagesView = [[SelectFriendsForMessageViewController alloc] initWithNibName:@"SelectFriendsForMessage" bundle:[NSBundle mainBundle]];
        
        messagesView.navigationItem.title = @"Select friends for message";
        UINavigationController *navController = 
        [[UINavigationController alloc] 
         initWithRootViewController:messagesView];
        
        UIPopoverController *popover = 
        [[UIPopoverController alloc] initWithContentViewController:navController]; 
        
        popover.delegate = self;
        
        self.messagingPopoverController = popover;
    }
    
    CGRect popoverRect = [self.view convertRect:[sender frame] 
                                       fromView:[sender superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100); 
    [self.messagingPopoverController 
     presentPopoverFromRect:popoverRect 
     inView:self.view 
     permittedArrowDirections:UIPopoverArrowDirectionAny 
     animated:YES];   
    
    
}

-(void)showLoginWithFacebookWizard
{
    ViewHelper *vh = [ViewHelper sharedManager];
    welcome3 = [[Welcome3EnableFacebookViewController alloc] initWithNibName:@"Welcome3EnableFacebook" bundle:nil AndReturnTo:self];
    currentWizardView =  welcome3.view;
    
    welcome3.view = [vh formatTheViewForDarkWizard:welcome3.view];
    
    [self.view addSubview:welcome3.view];
    [vh moveToStartPosition:currentWizardView ForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    
}

-(void)showSubscribeScreenInPopup {
    [self showSettingsforIPad:subscribeScreen];
}

-(void)showSubscribeScreen {
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        [self showSubscribeScreenInPopup];
    } 
    else
    {
        [self showSettingsView:subscribeScreen];
    }
}

-(void)showChangeVoiceScreenInPopup
{
    [self showSettingsforIPad:changeVoiceScreen];
}

-(void)showChangeVoiceScreen {
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        [self showChangeVoiceScreenInPopup];
    } 
    else
    {
        [self showSettingsView:changeVoiceScreen];
    }
}

- (IBAction)showMessaging:(id)sender {
    fromAppLoad = NO;
    
    [self hideAds];
    
    // reset target friends
    FacebookModel *fbModel = [FacebookModel sharedManager];
    [fbModel clearTargetFriends];
    
    
    
	UserModel *userModel = [UserModel userModel];
    
    if (userModel.userSettings.fbID!=nil && [userModel.userSettings.fbID intValue]!=-1)
    {
        if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
           UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
        {
            [self showMessagingInPopup:sender];
        } 
        else
        {
            // if user is logged into facebook, show messages view	
            SelectFriendsForMessageViewController *messagesView = [[SelectFriendsForMessageViewController alloc] initWithNibName:@"SelectFriendsForMessage" bundle:nil];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:messagesView];
            
            navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentModalViewController:navController animated:YES];
        }
    }
    else
    {
        // get the user to log in to FB
        [self showLoginWithFacebookWizard];
    }
	
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}



-(void)loginToFB
{
    FacebookModel *fbModel = [FacebookModel sharedManager];
    [fbModel fbLoginAndReturnTo:self];
}

-(void) facebookLoggedIn 
{
    justLoggedInToFacebook  = YES;
    
    FacebookModel *model = [FacebookModel sharedManager];
    
    [model getNameOfUserAndReturnTo:self];
}

-(void) facebookGotUserName:(NSString*)name andID:(NSString*)facebookID 
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *fbIDNum = [f numberFromString:facebookID];
	
	UserModel *userModel = [UserModel userModel];
	// save to model
	[userModel.userSettings setFbID:fbIDNum ];	
	[userModel.userSettings setUserFullName:name];
    
    [userModel saveUserSettings];
    
	FacebookModel *model = [FacebookModel sharedManager];
	//[model getMessageToPost];
    
    // now update the db with the users fbID 
    [model updateUsersFacebookIDWithFacebookID:userModel.userSettings.fbID andBedBuzzID:userModel.userSettings.bedBuzzID];
    
    // now fetch the friends
    [model getFacebookFriendsAndReturnTo:self];
}

-(void)refreshUnreadMessages
{
    MessagingModel *model = [MessagingModel sharedManager];
    [model refreshMessagesCount:self];
}

-(void) messageCountRefreshed:(int)numberOfMessages
{
    if (numberOfMessages > 0 )
    {
        [self showUnreadMessagesButton];
        
        // say unread messages
    }
}



- (IBAction)messageButtonPressed:(id)sender
{
    [flashMessagesTimer invalidate];
    UserModel *userModel = [UserModel userModel];
    
    mService = [[FetchMessagesService alloc] init];
    [mService fetchUnreadMessages:userModel.userSettings.fbID ThatAreOlderThanOneDay:NO AndReturnTo:self];
    
    messagesButton.hidden = YES;
}

-(void)showUnreadMessagesButton
{
    messagesButton.hidden = NO;
    
    flashMessagesTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                           target: self
                                                         selector: @selector(flashMessages)
                                                         userInfo: nil
                                                          repeats: YES];
}

-(void)flashMessages
{
    if (messagesButton.alpha == 0)
    {
        messagesButton.alpha = 1;
    }
    else
    {
        messagesButton.alpha = 0;
    }
}

-(void) messagesHaveBeenFetched
{
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector addMessagesToPlayQueueAndPlay];
    
    
    
}

-(void)showMessageSent
{
    
    messageSentLbl.hidden = NO;
    
    showMessageSentTimer = [NSTimer scheduledTimerWithTimeInterval: 3
                                                             target: self
                                                           selector: @selector(hideMessageSent)
                                                           userInfo: nil
                                                            repeats: NO];
    
}

-(void)hideMessageSent
{
    messageSentLbl.hidden = YES;
    
    [showMessageSentTimer invalidate];
    showMessageSentTimer = nil;
}

@end
