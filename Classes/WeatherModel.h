//
//  WeatherModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationUpdateDelegate.h"
#import "WeatherForecast.h"
#import "WeatherUpdatedDelegate.h"
#import "WUndergroundReport.h"
#import "SpeechGeneratedDelegate.h"
#import "WeatherSpeechGeneratedDelegate.h"
#import "WeatherUndergroundDelegate.h"

@interface WeatherModel : NSObject <CLLocationManagerDelegate, LocationUpdateDelegate, SpeechGeneratedDelegate, WeatherUndergroundDelegate> {
	
	id <WeatherUpdatedDelegate> weatherUpdatedDelegate;
    
    id <WeatherSpeechGeneratedDelegate> weatherSpeechGeneratedDelegate;
	
	CLLocationManager *locationManager;
	
	CLLocation *location;
	
    NSMutableArray *locationMeasurements;
	
	NSMutableDictionary *weatherConditions;
	
	id <LocationUpdateDelegate> delegate;
    
    NSString *currentWeatherTextDescFileName;
    
    NSString *currentWeatherTextDescriptionFetching;

    NSString *currentWeatherTextDescriptionFetched;
    
    NSString *currentVoiceUsedForTextDescription;
	
	BOOL backupWeatherTried;
	
	WeatherForecast *weatherNow;
	WeatherForecast *weatherToday;
	WeatherForecast *weatherTomorrow;
    WUndergroundReport *latestReport;
    
    NSDate *lastUpdated;
	
}
+ (id)weatherModel;
- (void)refreshWeatherAndReturnTo:(id <WeatherUpdatedDelegate>)delegateClass;
- (void)parseWeatherJSONFile;
- (void)stopUpdatingLocation:(NSString *)state;
- (void)updateHomeLocationAndReturnTo:(id <LocationUpdateDelegate>)delegate;
-(BOOL)isDark;
-(void)getWeatherFromWUnderground;
-(void)getVoiceForTextWeatherTomorrowAndReturnTo:(id <WeatherSpeechGeneratedDelegate>)delegateClass;
-(void)getVoiceForTextWeatherTodayAndReturnTo:(id <WeatherSpeechGeneratedDelegate>)delegateClass;

@property (strong, nonatomic) id <WeatherUpdatedDelegate> weatherUpdatedDelegate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *locationMeasurements;
@property (nonatomic, strong) NSMutableDictionary *weatherConditions;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSDate *lastUpdated;
@property (nonatomic, strong) WeatherForecast *weatherNow;
@property (nonatomic, strong) WeatherForecast *weatherToday;
@property (nonatomic, strong) WeatherForecast *weatherTomorrow;
@property (nonatomic, strong) WUndergroundReport *latestReport;
@property (strong, nonatomic) id <LocationUpdateDelegate> delegate;

@property (nonatomic, strong) NSString *currentWeatherTextDescriptionFetched;
@property (nonatomic, strong) NSString *currentVoiceUsedForTextDescription;


@end
