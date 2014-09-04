//
//  ClockModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ClockModel.h"
#import "AlarmsModel.h"
#import "AlarmGoingOffViewController.h"
#import "SoundDirector.h"
#import "UserModel.h"
#import "WeatherModel.h"

static ClockModel *sharedMyManager = nil;

@implementation ClockModel
@synthesize snoozeAlarm;
@synthesize currentHour;
@synthesize currentMinute;
@synthesize alarmViewController;
@synthesize isAlarmPlaying;
@synthesize isAlarmShowing;
@synthesize didAlarmJustPlay;

@synthesize alarmListenDelegate;

#pragma mark Singleton Methods
+ (id)clockModel {
	@synchronized(self) {
		if(sharedMyManager == nil)
			sharedMyManager = [[super allocWithZone:NULL] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self clockModel];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	return self;
}


- (void)startClock {
	// This starts the timer which fires the showActivity
	// method every 0.5 seconds
	myTicker = [NSTimer scheduledTimerWithTimeInterval: 0.5
												target: self
											  selector: @selector(showActivity)
											  userInfo: nil
											   repeats: YES];
	
}

-(void)stopClock {
	[myTicker invalidate];
}

-(BOOL)isReadyToCheckAlarms
{
    if (alarmListenDelegate==nil)
    {
        return NO;
    }
    
    // can check alarms if we are offline or have received weather
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isOfflineMode)
    {
        return YES;
    }
    
    WeatherModel *weatherModel = [WeatherModel weatherModel];
    if (weatherModel.weatherNow == nil)
    {
        return NO;
    }
    
    return YES;
}

// This method is run every 0.5 seconds by the timer created
// in the function runTimer
- (void)showActivity {
	
    NSDate *date = [NSDate date];
	
	
	// get the current minute
	NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
	NSInteger hour = [components hour];
	NSInteger minute = [components minute];
	
	// if the minute has changed, see if we have a valid alarm
	if (minute!=currentMinute && [self isReadyToCheckAlarms])
	{
		currentMinute = minute;
		currentHour = hour;
		
		if (! isAlarmPlaying)
		{
			[self checkAlarms];
		}
	}
	
}

-(BOOL)isAlarmEnabledToday:(Alarm*)alarm
{
	NSDate *date = [NSDate date];
	
	
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	
	// get the current minute
	NSDateComponents *components = [calendar components:(NSWeekdayCalendarUnit) fromDate:date];
	[components setCalendar:calendar];
	NSInteger day = [components weekday];
	BOOL isEnabled = NO;
	switch (day) {
		case 1:
			isEnabled = alarm.sunday;
			break;
		case 2:
			isEnabled = alarm.monday;
			break;
		case 3:
			isEnabled = alarm.tuesday;
			break;
		case 4:
			isEnabled = alarm.wednesday;
			break;
		case 5:
			isEnabled = alarm.thursday;
			break;
		case 6:
			isEnabled = alarm.friday;
			break;
		case 7:
			isEnabled = alarm.saturday;
			break;
		default:
			break;
	}
	
	//[components release];
	
	return isEnabled;
	
	
}

-(void)playAlarm:(Alarm *)alarm {
	// hurray this alarm should play
	isAlarmPlaying = true;
	SoundDirector *soundDirector = [SoundDirector soundDirector];
	[soundDirector playAlarm:alarm];
	[alarmListenDelegate alarmIsGoingOff];
	currentAlarm = alarm;
    didAlarmJustPlay = false;
	
}

- (void)checkAlarms
{
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	
	for (Alarm *alarm in sharedManager.alarms) {	
		if (alarm.enabled && alarm.hour == currentHour && alarm.mins == currentMinute && [self isAlarmEnabledToday:alarm])
		{
			// hurray this alarm should play
			isAlarmPlaying = YES;
			
			[alarmListenDelegate alarmIsGoingOff];
			currentAlarm = alarm;
			SoundDirector *soundDirector = [SoundDirector soundDirector];
			[soundDirector playAlarm:alarm];
		}
		
		if (isSnoozing && snoozeAlarm.enabled && snoozeHour == currentHour && snoozeMinute == currentMinute &&  [self isAlarmEnabledToday:snoozeAlarm])
		{
			// hurray this alarm should play
			
			//[alarmListenDelegate alarmIsGoingOff];
			[alarmViewController alarmIsGoingOff];
			SoundDirector *soundDirector = [SoundDirector soundDirector];
			[soundDirector playAlarm:snoozeAlarm];
		}
		
		// if alarm will go off in one minute, refresh the weather
		if (alarm.enabled && alarm.hour == currentHour && alarm.mins == (currentMinute+1) && [self isAlarmEnabledToday:alarm])
		{
			WeatherModel *weatherModel = [WeatherModel weatherModel];
			[weatherModel refreshWeatherAndReturnTo:self];
		}
	}
	
}

-(void)forgetSnooze {
    isSnoozing = NO;
}

-(void)weatherWasUpdated {
	
}

-(void)setSnoozeForCurrentAlarm {
	snoozeHour = currentHour;
	
	UserModel *userModel = [UserModel userModel];
	
	// get new mins for alarm
	NSDate *now = [NSDate date];
	NSDate* newDate = [now dateByAddingTimeInterval:userModel.userSettings.snoozeLength*60];
	NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

	NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:newDate];
	NSInteger newHour = [dateComponents hour];
	NSInteger newMins = [dateComponents minute];
	
	snoozeHour = newHour;
	snoozeMinute =newMins;
	snoozeAlarm = currentAlarm;
    isSnoozing = YES;
	
}

- (void)registerForAlarmGoingOff:(id <AlarmListenDelegate>)delegateClass
{
	alarmListenDelegate = delegateClass;
    
    // give it a check now
    [self checkAlarms];
	
}

-(void)letMeKnowWhenAlarmPlaysAfterSnooze:(id)alarmView
{
	isAlarmPlaying = NO;
	[self setAlarmViewController:alarmView];
}

@end
