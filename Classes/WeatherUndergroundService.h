//
//  WeatherUndergroundService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/4/14.
//  Copyright (c) 2014 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherUndergroundDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherUndergroundService : NSObject
{
    id <WeatherUndergroundDelegate> delegate;
    NSMutableData *_responseData;
}

@property (strong, nonatomic) id <WeatherUndergroundDelegate> delegate;

-(void)getWeatherForecastWithDelegate:(id<WeatherUndergroundDelegate>) delegateClass ForLocation:(CLLocationCoordinate2D)coordinate;

@end
