//
//  Alarm.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Alarm.h"


@implementation Alarm
@synthesize alarmName;
@synthesize hour;
@synthesize mins;
@synthesize sunday;
@synthesize monday;
@synthesize tuesday;
@synthesize wednesday;
@synthesize thursday;
@synthesize friday;
@synthesize saturday;
@synthesize enabled;
@synthesize alarmMusic;
	
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:alarmName forKey:@"alarmName"];
	[coder encodeObject:alarmMusic forKey:@"alarmMusic"];
	[coder encodeInt:hour forKey:@"hour"];
	[coder encodeInt:mins forKey:@"mins"];
	[coder encodeBool:sunday forKey:@"sunday"];
	[coder encodeBool:monday forKey:@"monday"];
	[coder encodeBool:tuesday forKey:@"tuesday"];
	[coder encodeBool:wednesday forKey:@"wednesday"];
	[coder encodeBool:thursday forKey:@"thursday"];
	[coder encodeBool:friday forKey:@"friday"];
	[coder encodeBool:saturday forKey:@"saturday"];
	[coder encodeBool:enabled forKey:@"enabled"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Alarm alloc] init];
    if (self != nil)
    {
        self.alarmName = [coder decodeObjectForKey:@"alarmName"];
		self.alarmMusic = [coder decodeObjectForKey:@"alarmMusic"];
		self.hour = [coder decodeIntForKey:@"hour"];
		self.mins = [coder decodeIntForKey:@"mins"];
		self.sunday = [coder decodeBoolForKey:@"sunday"];
		self.monday = [coder decodeBoolForKey:@"monday"];
		self.tuesday = [coder decodeBoolForKey:@"tuesday"];
		self.wednesday = [coder decodeBoolForKey:@"wednesday"];
		self.thursday = [coder decodeBoolForKey:@"thursday"];
		self.friday = [coder decodeBoolForKey:@"friday"];
		self.saturday = [coder decodeBoolForKey:@"saturday"];
		self.enabled = [coder decodeBoolForKey:@"enabled"];
    }   
    return self;
}

-(NSString *)getTimeString 
{
    NSDateFormatter *formatter =
	[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:date];
	[components setHour:self.hour];
	[components setMinute:self.mins];
    // This will produce a time that looks like "12:15:00 PM".
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
	
	
	
	NSString *minStr;
	if (self.mins < 10)
	{
		minStr =  [NSString stringWithFormat:@"0%d",self.mins];
	}
	else {
		minStr =  [NSString stringWithFormat:@"%d",self.mins];
	}
    
    NSString *amPMStr;
    if (self.hour < 12)
    {
        amPMStr = @"am";
    }
    else
    {
         amPMStr = @"pm";
    }
    
    int hourForStr = hour;
	// if amPMStr is empty, it means they have 24 hour mode on the iphone
	if ([amPMStr length] > 0)
	{
		if (hourForStr > 12)
		{
			hourForStr = hour - 12;
		}
	}
	
    
	NSString *timeStr = [NSString stringWithFormat:@"%d:%@ %@", hourForStr, minStr,amPMStr];
    
    
    
    return timeStr;
}

-(NSString *)getDaysString 
{
    NSMutableString *daysString = [[NSMutableString alloc] init];
    
    if (self.sunday)
    {
        [daysString appendString:@" Su "];
    }
    
    if (self.monday)
    {
        [daysString appendString:@" M "];
    }
    
    if (self.tuesday)
    {
        [daysString appendString:@" Tu "];
    }
    
    if (self.wednesday)
    {
        [daysString appendString:@" W "];
    }
    
    if (self.thursday)
    {
        [daysString appendString:@" Th "];
    }
    
    if (self.friday)
    {
        [daysString appendString:@" F "];
    }
    
    if (self.saturday)
    {
        [daysString appendString:@" Sa "];
    }
        
    
    return [daysString copy];
}



@end
