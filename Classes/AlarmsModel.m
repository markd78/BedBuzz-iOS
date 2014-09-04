//
//  AlarmsModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AlarmsModel.h"
#import "Alarm.h"
#import "MKLocalNotificationsScheduler.h"

static AlarmsModel *sharedMyManager = nil;

@implementation AlarmsModel

@synthesize alarms;
@synthesize selectedAlarm;

#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedMyManager == nil)
			sharedMyManager = [[super allocWithZone:NULL] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	alarms = [[NSMutableArray alloc] initWithObjects:nil];
	return self;
}


- (Alarm *)getDefaultAlarm {
		
	Alarm *alarm = [[Alarm alloc] init];
	alarm.hour = 7;
	alarm.mins = 0;
	alarm.enabled = true;
	alarm.sunday = true;
	alarm.monday = true;
	alarm.tuesday = true;
	alarm.wednesday = true;
	alarm.thursday = true;
	alarm.friday = true;
	alarm.saturday = true;
	NSString *alarmCountStr =[NSString stringWithFormat:@"%lu", alarms.count +1];
	alarm.alarmName = [@"Alarm " stringByAppendingString:alarmCountStr];
	
	return alarm;
}

-(void)scheduleAlarmNotification:(Alarm *)alarm ForDay:(int)day
{
	// 6th March is Sunday
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setTimeZone:[NSTimeZone localTimeZone]];
	[comps setYear:2011];
	[comps setMonth:3];
	[comps setSecond:0];
	
	NSCalendar *calender = [NSCalendar currentCalendar];
	[calender setTimeZone:[NSTimeZone localTimeZone]];
	switch (day) {
		case 0:
			[comps setDay:6];
			break;
		case 1:
			[comps setDay:7];
			break;
		case 2:
			[comps setDay:8];
			break;
		case 3:
			[comps setDay:9];
			break;
		case 4:
			[comps setDay:10];
			break;
		case 5:
			[comps setDay:11];
			break;
		case 6:
			[comps setDay:12];
			break;
		default:
			break;
	}
	
	//[comps setDay:29];
	[comps setHour:alarm.hour];
	[comps setMinute:alarm.mins];
	
	NSDate *dateToSet = [calender dateFromComponents:comps];
	
	[[MKLocalNotificationsScheduler sharedInstance] scheduleNotificationOn:dateToSet
																	  text:alarm.alarmName
																	action:@"View"
																	 sound:nil
															   launchImage:nil
																   andInfo:nil
																  forAlarm:alarm];
	
}

-(void)saveAlarms {
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[self alarms]] forKey:@"kAlarms"];
	[[NSUserDefaults standardUserDefaults]  synchronize];
	
	// remove all local notifications
	[[MKLocalNotificationsScheduler sharedInstance] removeNotifications];
	
	// now let's schedule the internal notifications
	for (Alarm *alarm in self.alarms)
	{		
		
		if (alarm.sunday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:0];
		}
		
		if (alarm.monday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:1];
		}
		
		if (alarm.tuesday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:2];
		}
		
		if (alarm.wednesday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:3];
		}
		
		if (alarm.thursday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:4];
		}
		
		if (alarm.friday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:5];
		}
		
		if (alarm.saturday && alarm.enabled)
		{
			[self scheduleAlarmNotification:alarm ForDay:6];
		}
		
		
	}
	
	
}


@end
