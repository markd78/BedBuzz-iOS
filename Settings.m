//
//  Settings.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


@implementation Settings

@synthesize voiceName;
@synthesize userFullName;
@synthesize isTwentyFourHourMode;
@synthesize isCelcius;
@synthesize shouldGreetWithName;
@synthesize snoozeLength;
@synthesize themeName;
@synthesize currentThemeImageName;
@synthesize showSeconds;
@synthesize additionalMessage;
@synthesize isUserTheme;
@synthesize fbID;
@synthesize appVersion;
@synthesize bedBuzzID;
@synthesize isPaidUser;
@synthesize changeVoiceNameCredits;
@synthesize sendMessageCredits;
@synthesize isKeepAwakeOn;
@synthesize isOfflineMode;
@synthesize subscriberUntilDate;
@synthesize numberOfAlarmsHappened;
@synthesize haveShownReviewRequest;
@synthesize haveShownHelpScreen;
@synthesize heardSelectFriendsMessage;
@synthesize heardComposeMessageHelp;
@synthesize hideFacebookBtn;
@synthesize showTitleBar;
@synthesize popupMessageCount;
@synthesize userHasChangedVoice;

- (void)encodeWithCoder:(NSCoder *)coder;
{
	[coder encodeInt:snoozeLength forKey:@"snoozeLength"];
	[coder encodeBool:isTwentyFourHourMode forKey:@"isTwentyFourHourMode"];
	[coder encodeBool:isCelcius forKey:@"isCelcius"];
	[coder encodeBool:shouldGreetWithName forKey:@"shouldGreetWithName"];
	[coder encodeObject:userFullName forKey:@"userFullName"];
	[coder encodeObject:voiceName forKey:@"voiceName"];
	[coder encodeObject:themeName forKey:@"themeName"];
	[coder encodeObject:additionalMessage forKey:@"additionalMessage"];
	[coder encodeObject:currentThemeImageName forKey:@"currentThemeImageName"];
	[coder encodeBool:isUserTheme forKey:@"isUserTheme"];
    [coder encodeBool:isKeepAwakeOn forKey:@"isKeepAwakeOn"];
	 [coder encodeObject:fbID  forKey:@"fbID"];
	[coder encodeObject:appVersion forKey:@"appVersion"];
	[coder encodeObject:bedBuzzID  forKey:@"bedBuzzID"];
	[coder encodeBool:isPaidUser  forKey:@"isPaidUser"];
    [coder encodeInt:changeVoiceNameCredits forKey:@"changeVoiceNameCredits"];
    [coder encodeInt:sendMessageCredits forKey:@"sendMessageCredits"];
    [coder encodeObject:subscriberUntilDate forKey:@"subscriberUntilDate"];
    [coder encodeInt:numberOfAlarmsHappened forKey:@"numberOfAlarmsHappened"];
    [coder encodeBool:haveShownReviewRequest  forKey:@"haveShownReviewRequest"];
    [coder encodeBool:haveShownHelpScreen  forKey:@"haveShownHelpScreen"];
    [coder encodeBool:heardSelectFriendsMessage  forKey:@"heardSelectFriendsMessage"];
    [coder encodeBool:heardComposeMessageHelp  forKey:@"heardComposeMessageHelp"];
    [coder encodeBool:hideFacebookBtn  forKey:@"hideFacebookBtn"];
    [coder encodeBool:showTitleBar  forKey:@"showTitleBar"];
     [coder encodeInt:popupMessageCount forKey:@"popupMessageCount"];
    [coder encodeBool:userHasChangedVoice  forKey:@"userHasChangedVoice"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Settings alloc] init];
    if (self != nil)
    {
		self.userFullName = [coder decodeObjectForKey:@"userFullName"];
		self.isTwentyFourHourMode = [coder decodeBoolForKey:@"isTwentyFourHourMode"];
		self.isCelcius = [coder decodeBoolForKey:@"isCelcius"];
		self.shouldGreetWithName = [coder decodeBoolForKey:@"shouldGreetWithName"];
		self.snoozeLength = [coder decodeIntForKey:@"snoozeLength"];
		self.themeName = [coder decodeObjectForKey:@"themeName"];
		self.voiceName = [coder decodeObjectForKey:@"voiceName"];
		self.additionalMessage = [coder decodeObjectForKey:@"additionalMessage"];
		self.currentThemeImageName = [coder decodeObjectForKey:@"currentThemeImageName"];
		self.fbID = [coder decodeObjectForKey:@"fbID"];
		self.appVersion = [coder decodeObjectForKey:@"appVersion"];
        self.isUserTheme = [coder decodeBoolForKey:@"isUserTheme"];
		self.bedBuzzID = [coder decodeObjectForKey:@"bedBuzzID"];
		self.isPaidUser = [coder decodeBoolForKey:@"isPaidUser"];
        self.changeVoiceNameCredits = [coder decodeIntForKey:@"changeVoiceNameCredits"];
         self.sendMessageCredits = [coder decodeIntForKey:@"sendMessageCredits"];
        self.isKeepAwakeOn = [coder decodeBoolForKey:@"isKeepAwakeOn"];
        self.subscriberUntilDate = [coder decodeObjectForKey:@"subscriberUntilDate"];
        self.numberOfAlarmsHappened = [coder decodeIntForKey:@"numberOfAlarmsHappened"];
         self.haveShownReviewRequest = [coder decodeBoolForKey:@"haveShownReviewRequest"];
        self.haveShownHelpScreen = [coder decodeBoolForKey:@"haveShownHelpScreen"];
        self.heardSelectFriendsMessage = [coder decodeBoolForKey:@"heardSelectFriendsMessage"];
        self.heardComposeMessageHelp = [coder decodeBoolForKey:@"heardComposeMessageHelp"];
        self.hideFacebookBtn = [coder decodeBoolForKey:@"hideFacebookBtn"];
        self.showTitleBar = [coder decodeBoolForKey:@"showTitleBar"];
        self.popupMessageCount = [coder decodeIntForKey:@"popupMessageCount"];
        self.userHasChangedVoice = [coder decodeBoolForKey:@"userHasChangedVoice"];
    }
	return self;
	
}

-(BOOL)isSubscriptionRunningOut 
{
    if ( [self isSubscriptionExpired])
    {
        // if already expired, this should return false
        return NO;
    }
    
    if ( subscriberUntilDate == nil)
    {
        return NO;    
    }
    
    int numberOfSecondsIn2Weeks = 14*24*60*60;
    NSDate* subscibeEndDateMinus2Weeks = [subscriberUntilDate dateByAddingTimeInterval:0-numberOfSecondsIn2Weeks];
    
    NSComparisonResult result; 
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
      NSDate *now = [NSDate date];
    result = [now compare:subscibeEndDateMinus2Weeks]; // comparing two dates
    
    if(result==NSOrderedAscending)
        return NO;
    else if(result==NSOrderedDescending)
        return YES;
    else
        return YES;

}

-(BOOL)isSubscriptionExpired
{
    if ( subscriberUntilDate == nil)
    {
        return NO;    
    }
    
    NSComparisonResult result; 
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    NSDate *now = [NSDate date];
    result = [now compare:subscriberUntilDate]; // comparing two dates
    
    if(result==NSOrderedAscending)
        return NO;
    else if(result==NSOrderedDescending)
        return YES;
    else
        return YES;
}

@end
