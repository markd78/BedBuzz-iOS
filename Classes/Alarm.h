//
//  Alarm.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Alarm : NSObject <NSCoding> {
	NSString *alarmName;
	NSInteger hour;
	NSInteger mins;
	BOOL sunday;
	BOOL monday ;
	BOOL tuesday;
	BOOL wednesday;
	BOOL thursday;
	BOOL friday;
	BOOL saturday;
	
	BOOL enabled ;
	
	MPMediaItemCollection *alarmMusic;
}

@property (nonatomic, strong) NSString *alarmName;
@property (nonatomic, strong) MPMediaItemCollection *alarmMusic;
@property (nonatomic) BOOL sunday;
@property (nonatomic) BOOL monday;
@property (nonatomic) BOOL tuesday;
@property (nonatomic) BOOL wednesday;
@property (nonatomic) BOOL thursday;
@property (nonatomic) BOOL friday;
@property (nonatomic) BOOL saturday;
@property (nonatomic) BOOL enabled;
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger mins;

/* Conform with NSCoding protocol */
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;
-(NSString *)getDaysString ;
-(NSString *)getTimeString ;
@end
