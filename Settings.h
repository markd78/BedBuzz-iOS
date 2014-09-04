//
//  Settings.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Settings : NSObject  <NSCoding> {
	NSString *userFullName;
	NSString *voiceName;
	NSString *themeName;
	BOOL isTwentyFourHourMode;
	BOOL isCelcius;
	BOOL shouldGreetWithName;
	BOOL showSeconds;
    BOOL isKeepAwakeOn;
	NSInteger snoozeLength;
	NSString *currentThemeImageName;
	NSString *additionalMessage;
	BOOL isUserTheme;
	NSNumber *fbID;
	NSNumber *appVersion;
	NSNumber *bedBuzzID;
	BOOL isPaidUser;
    NSInteger changeVoiceNameCredits;
    NSInteger sendMessageCredits;
    BOOL isOfflineMode;
    NSDate *subscriberUntilDate;
    NSInteger numberOfAlarmsHappened;
    BOOL haveShownReviewRequest;
    BOOL haveShownHelpScreen;
    BOOL heardSelectFriendsMessage;
    
    BOOL heardComposeMessageHelp;
    
    BOOL hideFacebookBtn;
    
     BOOL showTitleBar;
    
    BOOL userHasChangedVoice;
    
    NSInteger popupMessageCount;
}

@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *voiceName;
@property (nonatomic, strong) NSString *themeName;
@property (nonatomic, strong) NSString *currentThemeImageName;
@property (nonatomic, strong) NSString *additionalMessage;
@property (nonatomic) BOOL isTwentyFourHourMode;
@property (nonatomic) BOOL isCelcius;
@property (nonatomic) BOOL shouldGreetWithName;
@property (nonatomic) BOOL showSeconds;
@property (nonatomic) BOOL isUserTheme;
@property (nonatomic) BOOL isOfflineMode;
@property (nonatomic) BOOL isKeepAwakeOn;
@property (nonatomic, strong) NSNumber *fbID;
@property (nonatomic) NSInteger snoozeLength;
@property (nonatomic, strong) NSNumber *appVersion;
@property (nonatomic, strong) NSNumber *bedBuzzID;
@property (nonatomic) BOOL isPaidUser;
@property (nonatomic) NSInteger changeVoiceNameCredits;
@property (nonatomic) NSInteger sendMessageCredits;
@property (nonatomic, strong) NSDate *subscriberUntilDate;
@property (nonatomic) NSInteger numberOfAlarmsHappened;
@property (nonatomic) BOOL haveShownReviewRequest;
@property (nonatomic) BOOL haveShownHelpScreen;
@property (nonatomic) BOOL heardSelectFriendsMessage;
@property (nonatomic) BOOL heardComposeMessageHelp;
@property (nonatomic) BOOL hideFacebookBtn;
@property (nonatomic) BOOL showTitleBar;
@property (nonatomic) BOOL userHasChangedVoice;
@property (nonatomic) NSInteger popupMessageCount;

-(BOOL)isSubscriptionRunningOut ;
-(BOOL)isSubscriptionExpired;

@end
