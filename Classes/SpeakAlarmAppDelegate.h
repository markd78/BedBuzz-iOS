//
//  SpeakAlarmAppDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewController.h"
#import "AlarmListenDelegate.h"
#import "RootViewController_Old.h"
#import "LoginServiceDelegate.h"
#import "WeatherUpdatedDelegate.h"
#import "WelcomeViewController.h"

@interface SpeakAlarmAppDelegate : NSObject <UIApplicationDelegate, LoginServiceDelegate, WeatherUpdatedDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    ClockViewController *clockViewController;
	RootViewController_Old *rootViewController;
    WelcomeViewController *loginViewController;
    BOOL alarmShouldPlay;
   BOOL isAppearingFromBackground;
                        BOOL isFromNotification;
    NSString *alarmNameToPlay;
                        BOOL isFromReturnFromFacebookApp;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) ClockViewController *clockViewController;

@property (nonatomic, strong) RootViewController_Old *rootViewController;
@property (nonatomic, strong) WelcomeViewController *loginViewController;

-(void)setUp:(BOOL)fromAlarm;
-(void)loadAlarms;
-(void)showScreen;
-(void)showAds;
-(void)weatherWasUpdated;
-(void)alarmFinished;
-(void)showSubscribeWizard;
-(void)showSendFirstMessageDialog;

@end
