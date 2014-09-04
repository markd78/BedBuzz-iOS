//
//  MKLocalNotificationsScheduler.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "Alarm.h"

@interface MKLocalNotificationsScheduler : NSObject {

}

+ (MKLocalNotificationsScheduler*) sharedInstance;
-(void) removeNotifications;
- (void) scheduleNotificationOn:(NSDate*) fireDate
						   text:(NSString*) alertText
						 action:(NSString*) alertAction
						  sound:(NSString*) soundfileName
					launchImage:(NSString*) launchImage
						andInfo:(NSDictionary*) userInfo
					   forAlarm:(Alarm *) alarm;

@end
