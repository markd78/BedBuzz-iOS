//
//  WeatherModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "WeatherModel.h"
#import "WeatherCondition.h"
#import "WUndergroundReport.h"
#import "AmazonPoly.h"
#import "UserModel.h"
#import "WeatherSpeechGeneratedDelegate.h"
#import "WeatherUndergroundService.h"

static WeatherModel *sharedWeatherModel = nil;


@implementation WeatherModel
@synthesize	 locationManager;
@synthesize	 location;
@synthesize	 locationMeasurements;
@synthesize delegate;
@synthesize weatherConditions;
@synthesize weatherNow;
@synthesize weatherToday;
@synthesize weatherTomorrow;
@synthesize weatherUpdatedDelegate;
@synthesize lastUpdated;
@synthesize latestReport;
@synthesize currentVoiceUsedForTextDescription;
@synthesize currentWeatherTextDescriptionFetched;

#pragma mark Singleton Methods
+ (id)weatherModel {
	@synchronized(self) {
		if(sharedWeatherModel == nil)
			sharedWeatherModel = [[super allocWithZone:NULL] init];
	}
	return sharedWeatherModel;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self weatherModel];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}


- (id)init
{
	self = [super init];
	self.locationMeasurements = [NSMutableArray array];
	return self;
}


// get current location
- (void)updateHomeLocationAndReturnTo:(id <LocationUpdateDelegate>)delegateClass
{
	// Create the manager object 
    location =nil;
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [self.locationManager requestWhenInUseAuthorization];
	
	[locationManager startUpdatingLocation];
	[self setDelegate:delegateClass];
}


/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
	
	// store all of the measurements, just so we can see what kind of data we might receive
    [locationMeasurements addObject:newLocation];
   
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (location == nil || location.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.location = newLocation;
        
		[self stopUpdatingLocation:@"Acquired Location"];
		// we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
		//  }
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// The location "unknown" error simply means the manager is currently unable to get the location.
	// We can ignore this error for the scenario of getting a single location fix, because we already have a 
	// timeout that will stop the location manager to save power.
	if ([error code] != kCLErrorLocationUnknown) {
		[self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
	}
}

- (void)stopUpdatingLocation:(NSString *)state {
	[locationManager stopUpdatingLocation];
	locationManager.delegate = nil;
	[delegate locationUpdated];
}

// parse my JSON file, containing all possible weather forecasts (to match to weather Images and sounds
-(void)parseWeatherJSONFile {
	
	NSString *resource = [[NSBundle mainBundle] pathForResource:@"wwoConditionCodes" ofType:@"json"];
	NSString *content = [NSString stringWithContentsOfFile:resource  encoding:NSUTF8StringEncoding error:nil];
	
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];

	NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

	[self setWeatherConditions:[[NSMutableDictionary alloc] init]];
	
	NSMutableArray *conditions = [resultDict objectForKey:@"condition"];
	
	for (NSDictionary *conditionDict in conditions) {
		
		// create new weatherConditon object
		WeatherCondition *conditionObj = [[WeatherCondition alloc] init];
		conditionObj.code = [conditionDict objectForKey:@"code"];
		conditionObj.weatherDescription = [conditionDict objectForKey:@"description"];
		conditionObj.dayIcon= [conditionDict objectForKey:@"day_icon"];
		conditionObj.nightIcon= [conditionDict objectForKey:@"night_icon"];
		conditionObj.soundFileName= [conditionDict objectForKey:@"sound"];

		
		// and add it the conditions dictionary, with the weather code as the key
		[weatherConditions setObject:conditionObj forKey:conditionObj.code]; 
        
	 }
    
}

-(BOOL)isDateMoreThanHourAgo:(NSDate *)dateToCompare
{
    if (dateToCompare == nil)
    {
        return YES;
    }
    // diff is in seconds
    NSTimeInterval diff = [dateToCompare timeIntervalSinceNow];
    if ( (0-diff) > 3600)
    {
        return YES;
    }
    
    return NO;
}

-(void) refreshWeatherAndReturnTo:(id <WeatherUpdatedDelegate>)delegateClass {

    if ([self isDateMoreThanHourAgo:self.lastUpdated])
    {
    
        [self setWeatherUpdatedDelegate:delegateClass];

	
        // get current location
        [self updateHomeLocationAndReturnTo:self];
        
        
        self.lastUpdated = [NSDate date];
    }
    else {
        
        [weatherUpdatedDelegate weatherWasUpdated];
    }
}

-(void)locationUpdated {
	//[self getWeather:NO];
	[self getWeatherFromWUnderground];
}

-(void)getWeatherFromWUnderground
{
    
    WeatherUndergroundService *wundergroundService = [[WeatherUndergroundService alloc] init];
    [wundergroundService getWeatherForecastWithDelegate:self ForLocation:location.coordinate];
    
}

- (void)weatherLoaded:(NSDictionary *)resultDict
 {
     
     self.latestReport = [WUndergroundReport fromResponse:resultDict];
     
     [self setWeatherNow:[[WeatherForecast alloc] init]];
     [self setWeatherToday:[[WeatherForecast alloc] init]];
     [self setWeatherTomorrow:[[WeatherForecast alloc] init]];
     
     weatherNow.currentTempF = [self.latestReport tempf];
     weatherNow.currentTempC = [self.latestReport tempc];
     NSString *weatherCodeNow =  [NSString stringWithFormat:@"%d", [self.latestReport weatherCode]]; ;
     weatherNow.condition = [weatherConditions valueForKey:weatherCodeNow];
     
     
     ///// TODAY 
     weatherToday.sunriseHour = [self.latestReport sunriseHour];
     weatherToday.sunriseMin = [self.latestReport sunriseMinute];
     weatherToday.sunsetHour = [self.latestReport  sunsetHour];
     weatherToday.sunsetMin = [self.latestReport  sunsetMinute];
     
     weatherToday.maxTempF = [self.latestReport todayMaxTempF] ;
     weatherToday.maxTempC = [self.latestReport todayMaxTempC];
      NSString *weatherCodeToday =  [NSString stringWithFormat:@"%d", [self.latestReport weatherCodeToday]]; ;
     weatherToday.condition = [weatherConditions objectForKey:weatherCodeToday];
     weatherToday.condition.textDescription = [self.latestReport todayTextCondition];
                                                
     ///// TOMORROW 
     weatherTomorrow.maxTempF = [self.latestReport tomorrowMaxTempF] ;     weatherTomorrow.maxTempC = [self.latestReport tomorrowMaxTempC] ;
      NSString *weatherCodeTomorrow =  [NSString stringWithFormat:@"%d", [self.latestReport weatherCodeTomorrow]]; ;
     
     weatherTomorrow.condition = [weatherConditions objectForKey:weatherCodeTomorrow];
     weatherTomorrow.condition.textDescription = [self.latestReport tomorrowTextCondition];
     
     [weatherUpdatedDelegate weatherWasUpdated];
 }


-(BOOL)isDark  {
	NSDate *now = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:now];
	NSInteger minNow = [dateComponents minute];
	NSInteger hourNow = [dateComponents hour];
	
	if (hourNow < weatherToday.sunriseHour)
	{
		return YES;
	}
	
	if (hourNow == weatherToday.sunriseHour && minNow < weatherToday.sunriseMin)
	{
		return YES;
	}
	
	if (hourNow > weatherToday.sunsetHour)
	{
		return YES;
	}
	
	if (hourNow == weatherToday.sunsetHour && minNow > weatherToday.sunsetMin)
	{
		return YES;
	}
	
	return NO;
}

// fetch the sound for the weather service
- (void) fetchWeatherDescription:(NSString *)weatherTxt {
	
    currentWeatherTextDescriptionFetching = weatherTxt;
	
    UserModel *userModel = [ UserModel userModel];
    
    if (userModel.userSettings.voiceName == nil)
    {
        userModel.userSettings.voiceName = @"ukenglishfemale1";
    }
    
	// generate the sounds	
	AmazonPoly *iSpeech = [[AmazonPoly alloc] init];
	[iSpeech startGenerateSpeech:weatherTxt AndSaveToFileName:@"weatherTxt.mp3" withVoice:userModel.userSettings.voiceName AndReturnTo:self];
	
} 

- (void)speechGenerated;
{
	// add the file to the sounddirector queue - if no sounds are playing, then play the sound 
    UserModel *um = [UserModel userModel];
	currentWeatherTextDescriptionFetched = currentWeatherTextDescriptionFetching;
	currentVoiceUsedForTextDescription = um.userSettings.voiceName;
    
    [weatherSpeechGeneratedDelegate weatherSpeechGenerated];
}

-(void)getVoiceForTextWeatherTodayAndReturnTo:(id <WeatherSpeechGeneratedDelegate>)delegateClass;

{
    weatherSpeechGeneratedDelegate = delegateClass;
     UserModel *um = [UserModel userModel];
    
    if ([self.weatherToday.condition.textDescription isEqualToString:currentWeatherTextDescriptionFetched] && [currentVoiceUsedForTextDescription isEqualToString:um.userSettings.voiceName])
    {
        // don't need to fetch the speech (its the same) just play it
        [self speechGenerated];
    }
    else
    {
        [self fetchWeatherDescription:self.weatherToday.condition.textDescription];
    }
}

-(void)getVoiceForTextWeatherTomorrowAndReturnTo:(id <WeatherSpeechGeneratedDelegate>)delegateClass;

{
     weatherSpeechGeneratedDelegate = delegateClass;
    UserModel *um = [UserModel userModel];
    
    if ([self.weatherToday.condition.textDescription isEqualToString:currentWeatherTextDescriptionFetched] && [currentVoiceUsedForTextDescription isEqualToString:um.userSettings.voiceName])
    {
        // don't need to fetch the speech (its the same) just play it
        [self speechGenerated];
    }
    else
    {
        [self fetchWeatherDescription:self.weatherTomorrow.condition.textDescription];
    }
}

@end
