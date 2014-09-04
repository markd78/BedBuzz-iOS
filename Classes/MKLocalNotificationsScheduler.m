//
//  MKLocalNotificationsScheduler.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "MKLocalNotificationsScheduler.h"


static MKLocalNotificationsScheduler *_instance;
@implementation MKLocalNotificationsScheduler

+ (MKLocalNotificationsScheduler*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[super allocWithZone:NULL] init];
            
            // Allocate/initialize any member variables of the singleton class her
            // example
			//_instance.member = @"";
        }
    }
	
	// iOS 4 compatibility check
	Class notificationClass = NSClassFromString(@"UILocalNotification");
	
	if(notificationClass == nil)
	{
		_instance = nil;
	}
	else
	{
		_instance = [[super allocWithZone:NULL] init];
	}
	
    return _instance;
}

-(void) removeNotifications {
		[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void) scheduleNotificationOn:(NSDate*) fireDate
						   text:(NSString*) alertText
						 action:(NSString*) alertAction
						  sound:(NSString*) soundfileName
					launchImage:(NSString*) launchImage
						andInfo:(NSDictionary*) userInfo
						forAlarm:(Alarm *) alarm

{
	
	UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone localTimeZone];
	localNotification.repeatInterval = kCFCalendarUnitWeek;
	localNotification.hasAction = YES;
    
	NSCalendar *calender = [NSCalendar currentCalendar];
	localNotification.repeatCalendar = calender;
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;	
	
	if(soundfileName == nil)
	{
		localNotification.soundName = @"/media/artofgardens30secs.aif";
	}
	
	localNotification.alertLaunchImage = launchImage;
	
	// make simple dictionary containing alarm name
	NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys:
						   alarm.alarmName, @"alarmName", nil];

	
    localNotification.userInfo = entry;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
	return [self sharedInstance];	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}


@end
