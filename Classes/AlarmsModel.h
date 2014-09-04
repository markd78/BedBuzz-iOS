//
//  AlarmsModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"


@interface AlarmsModel : NSObject {
	
	NSMutableArray *alarms;
	Alarm *selectedAlarm;
	
}

@property (nonatomic, strong) NSMutableArray *alarms;
@property (nonatomic, strong) Alarm *selectedAlarm;
- (Alarm *) getDefaultAlarm ;
-(void)saveAlarms;
+ (id)sharedManager;

@end
