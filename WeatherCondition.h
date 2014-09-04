//
//  WeatherCondition.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherCondition : NSObject {
	NSString *code;
	NSString *weatherDescription;
	NSString *dayIcon;
	NSString *nightIcon;
	NSString *soundFileName;
}

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *weatherDescription;
@property (nonatomic, strong) NSString *dayIcon;
@property (nonatomic, strong) NSString *nightIcon;
@property (nonatomic, strong) NSString *soundFileName;
@property (nonatomic, strong) NSString *textDescription;

@end
