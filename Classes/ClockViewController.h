//
//  Clock.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "WeatherUpdatedDelegate.h"
#import "AlarmListenDelegate.h"
#import "AlarmGoingOffViewController.h"
#import "FacebookGotFriendsDelegate.h"
#import "FacebookLoggedInDelegate.h"
#import "FacebookGotUserNameDelegate.h"
#import "GetUnreadMessagesCountDelegate.h"
#import "FetchMessagesService.h"
#import "FetchMessagesDelegate.h"
#import "SettingsViewController.h"
#import "HelpScreenViewController.h"
#import "HelpScreenDelegate.h"
#import "WizardDelegate.h"
#import "RedirectingToFacebookViewController.h"
#import "Welcome3EnableFacebookViewController.h"
#import "ViewHelper.h"
#import "Reachability.h"
#import "SubscribeQuestionViewController.h"
#import "ChangeVoiceQuestionViewController.h"

@interface ClockViewController : UIViewController <WeatherUpdatedDelegate, AlarmListenDelegate,FacebookGotFriendsDelegate, FacebookLoggedInDelegate, FacebookGotUserNameDelegate, GetUnreadMessagesCountDelegate, FetchMessagesDelegate, UIPopoverControllerDelegate,ADBannerViewDelegate, HelpScreenDelegate, WizardDelegate> {
	IBOutlet UIImageView* backgroundImageView;
	IBOutlet UIImageView* weatherImageView;
	IBOutlet UILabel* weatherTempLbl;
	IBOutlet UILabel* weatherTempUnitLbl;
    IBOutlet UILabel* messageSentLbl;
	IBOutlet UILabel* ampmLbl;
	IBOutlet UIButton* infoButton;
	IBOutlet UILabel* clockLabel;
	IBOutlet UILabel* dateLabel;
    IBOutlet UIButton* facebookButton;
    IBOutlet UIButton* messagesButton;
    IBOutlet UIView* timeView;
    IBOutlet UIView* weatherView;
    IBOutlet UIButton* powerButton;
    IBOutlet ADBannerView* adBannerView;
    
    Reachability* internetReach;
    BOOL isShowingAds;
    BOOL justLoggedInToFacebook;
    BOOL fromAppLoad;
    BOOL iPadAdBannerVisible;
    BOOL isWeatherMovedDown;
    UIView *currentWizardView;
    
     UIPopoverController *settingsPopoverController;
    UIPopoverController *messagingPopoverController;
    RedirectingToFacebookViewController *redirectScreen;
	IBOutlet UIActivityIndicatorView *refreshWeatherSpinner;
    IBOutlet UIActivityIndicatorView *refreshFriendsSpinner;
	AlarmGoingOffViewController *alarmGoingOffViewController;
	 NSTimer *myTicker;
    NSTimer *flashMessagesTimer;
    NSTimer *flashPowerTimer;
     NSTimer *showMessageSentTimer;
	NSString *currentThemeType;
     NSTimer *weatherTimer;
    FetchMessagesService *mService;
    HelpScreenViewController *helper;
    Welcome3EnableFacebookViewController *welcome3;
    CGFloat currentWidth;
    CGFloat currentHeight;
    
}

/* New Methods */
- (IBAction)showSettings:(id)sender;

- (IBAction)showMessaging:(id)sender;

- (IBAction)messageButtonPressed:(id)sender;

- (IBAction)powerButtonPressed:(id)sender;
- (void) updateInterfaceWithReachability: (Reachability*) curReach;
-(void)showRefreshingWeatherSpinner;
- (void)runTimer;
//-(void)showAds;
-(void)hideAds;
-(void)gotFacebookFriends;
-(void)drawScreen;
-(void)hideRefreshingWeatherSpinner;
-(void)hideRefreshingFriendsSpinner;
-(void)showRefreshingFriendsSpinner;
-(void) facebookLoggedIn ;
-(void)loginToFB;
-(void) facebookGotUserName:(NSString*)name andID:(NSString*)facebookID ;
-(void)showSettingsView:(WizardScreen)showFromWizardScreen;
-(void)refreshUnreadMessages;
-(void)showUnreadMessagesButton;
-(void)weatherWasUpdated;
-(void)showOrHidePowerButton;
-(void)showPowerButton;
-(void)registerForAlarmGoingOff ;
-(void)refreshTempText;
-(void)showMessageSent;
- (void)showAdBannerForiPad;
-(void)alarmFinished;
-(void)showSettingsforIPad:(WizardScreen)fromWizardScreen;
-(void)refreshWeather;
-(void)repositionAdsForIpad;
-(void)showSendMessageQuestion;
-(void)showChangeVoiceQuestion;
-(void)showChangeVoiceScreenInPopup;
-(void)showSubscribeScreenInPopup;
-(void)showSubscribeQuestion:(BOOL)withSound;
-(void)hideTapForTapAdsIfNeeded;

@property (nonatomic, strong) SettingsViewController *settingsViewController; 
@property (nonatomic, strong) HelpScreenViewController *helper; 
@property (nonatomic, strong) UIPopoverController *settingsPopoverController; 
@property (nonatomic, strong) UIPopoverController *messagingPopoverController; 
@property (nonatomic, strong) NSString *currentThemeType;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *weatherTempLbl;
@property (nonatomic, strong) IBOutlet UILabel *ampmLbl;
@property (nonatomic, strong) IBOutlet UILabel *weatherTempUnitLbl;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UIButton *facebookButton;
@property (nonatomic, strong) IBOutlet UIImageView *weatherImageView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong)  FetchMessagesService *mService;
@property (nonatomic, strong)  UIButton *settingsBtn;
@property (nonatomic, strong)  RedirectingToFacebookViewController *redirectScreen;
@property (nonatomic, strong)  Welcome3EnableFacebookViewController *welcome3;
@property (nonatomic, strong) SubscribeQuestionViewController *subscribeWizard;
@property (nonatomic, strong) ChangeVoiceQuestionViewController *changeVoiceWizard;
@end
