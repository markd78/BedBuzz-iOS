//
//  TimeCustomCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeCustomCell.h"
#import "AlarmsModel.h"

@implementation TimeCustomCell
@synthesize timeLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		
    }
    return self;
}

-(NSString *)getTimeString 
{
    AlarmsModel *sharedManager = [AlarmsModel sharedManager];
    
    NSDateFormatter *formatter =
	[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:date];
	[components setHour:sharedManager.selectedAlarm.hour];
	[components setMinute:sharedManager.selectedAlarm.mins];
    // This will produce a time that looks like "12:15:00 PM".
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
	
	
	
	NSString *minStr;
	if (sharedManager.selectedAlarm.mins < 10)
	{
		minStr =  [NSString stringWithFormat:@"0%d",sharedManager.selectedAlarm.mins];
	}
	else {
		minStr =  [NSString stringWithFormat:@"%d",sharedManager.selectedAlarm.mins];
	}
    
    NSString *amPMStr;
    if (sharedManager.selectedAlarm.hour < 12)
    {
        amPMStr = @"am";
    }
    else
    {
        amPMStr = @"pm";
    }
    
    int hourForStr = sharedManager.selectedAlarm.hour;
	// if amPMStr is empty, it means they have 24 hour mode on the iphone
	if ([amPMStr length] > 0)
	{
		if (hourForStr > 12)
		{
			hourForStr = sharedManager.selectedAlarm.hour - 12;
		}
	}
	
    
	NSString *timeStr = [NSString stringWithFormat:@"%d:%@ %@", hourForStr, minStr,amPMStr];
    
    
    
    return timeStr;
}



@end
