//
//  ClockModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"
#import "AlarmListenDelegate.h"
#import "AlarmGoingOffViewController.h"
#import "WeatherUpdatedDelegate.h"

@interface ClockModel : NSObject <WeatherUpdatedDelegate> {
	NSInteger currentMinute;
	NSInteger currentHour;
	NSInteger snoozeMinute;
	NSInteger snoozeHour;
	Alarm *snoozeAlarm;
	Alarm *currentAlarm;
	NSTimer *myTicker;
	id <AlarmListenDelegate> alarmListenDelegate;
	AlarmGoingOffViewController *alarmViewController;
	BOOL isAlarmPlaying;
    BOOL isAlarmShowing;
    BOOL isSnoozing;
    BOOL didAlarmJustPlay;
}

- (void)registerForAlarmGoingOff:(id <AlarmListenDelegate>)delegateClass;

-(BOOL)isAlarmEnabledToday:(Alarm*)alarm;

+ (id)clockModel;

- (void) startClock;
- (void) stopClock;
- (void)showActivity;
- (void)checkAlarms;
-(void)setSnoozeForCurrentAlarm;
-(void)letMeKnowWhenAlarmPlaysAfterSnooze:(id)alarmView;
-(void)playAlarm:(Alarm *)alarm;
-(void)weatherWasUpdated;
-(void)forgetSnooze;

@property (nonatomic,strong) Alarm *snoozeAlarm;
@property (nonatomic) NSInteger currentMinute;
@property (nonatomic) BOOL isAlarmPlaying;
@property (nonatomic) BOOL isAlarmShowing;
@property (nonatomic) BOOL didAlarmJustPlay;
@property (nonatomic) NSInteger currentHour;
@property (strong, nonatomic) id <AlarmListenDelegate> alarmListenDelegate;
@property (strong, nonatomic) id  alarmViewController;
@end
