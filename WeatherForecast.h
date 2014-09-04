//
//  WeatherForecast.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCondition.h"

@interface WeatherForecast : NSObject {
	int currentTempF;
	int currentTempC;
	int minTempF;
	int maxTempF;
	int minTempC;
	int maxTempC;
	WeatherCondition *condition;
	int sunsetHour;
	int sunsetMin;
	int sunriseHour;
	int sunriseMin;
	
}

@property (nonatomic) int currentTempF;
@property (nonatomic) int currentTempC;
@property (nonatomic) int minTempF;
@property (nonatomic) int maxTempF;
@property (nonatomic) int minTempC;
@property (nonatomic) int maxTempC;
@property (nonatomic) int sunsetHour;
@property (nonatomic) int sunsetMin;
@property (nonatomic) int sunriseHour;
@property (nonatomic) int sunriseMin;
@property (nonatomic, strong) WeatherCondition *condition;

@end
