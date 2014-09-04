//
// Created by Matt Greenfield on 2/02/12.
// Copyright Big Paua 2012. All rights reserved.
//

#import "WUndergroundReport.h"
#import "UserModel.h"

@implementation WUndergroundReport {
    NSDate *timestamp;
}

@synthesize response, rawWeather, rawAstronomy, rawSimpleForecastToday, rawSimpleForecastTomorrow, rawTxtToday, rawTxtTomorrow;

- (id)init {
    self = [super init];
    return self;
}

+ (WUndergroundReport *)fromResponse:(NSDictionary *)response {
    WUndergroundReport *report = [[WUndergroundReport alloc] init];
    report.response = response;
    return report;
}

- (void)setResponse:(NSDictionary *)_response {
    response = _response;
    self.rawWeather = [_response objectForKey:@"current_observation"];
    self.rawAstronomy = [_response objectForKey:@"moon_phase"];
    
    NSDictionary *forecast = [_response objectForKey:@"forecast"];
    NSDictionary *simpleForecast = [forecast objectForKey:@"simpleforecast"];
    
    
    NSArray *forecasts = [simpleForecast valueForKeyPath:@"forecastday"];
    self.rawSimpleForecastToday = [forecasts objectAtIndex:0];
     self.rawSimpleForecastTomorrow = [forecasts objectAtIndex:1];
    
    NSDictionary *txt_forecast = [forecast objectForKey:@"txt_forecast"];
    
    
    NSArray *forecastsTxt = [txt_forecast valueForKeyPath:@"forecastday"];

    self.rawTxtToday = [forecastsTxt objectAtIndex:0];
    self.rawTxtTomorrow = [forecastsTxt objectAtIndex:2];
    
    timestamp = [NSDate date];
    
}

- (NSString *)todayTextCondition
{
    UserModel *um = [UserModel userModel];
    if (um.userSettings.isCelcius)
    {
        return [rawTxtToday objectForKey:@"fcttext_metric"];
       
    }
    else {
         return [rawTxtToday objectForKey:@"fcttext"];
    }
}


- (NSString *)tomorrowTextCondition
{
    UserModel *um = [UserModel userModel];
    if (um.userSettings.isCelcius)
    {
        return [rawTxtTomorrow objectForKey:@"fcttext_metric"];
        
    }
    else {
        return [rawTxtTomorrow objectForKey:@"fcttext"];
    }
}

- (NSTimeInterval)age {
    NSTimeInterval
    epoch = [[rawWeather objectForKey:@"observation_epoch"] floatValue];
    NSDate *observed = [NSDate dateWithTimeIntervalSince1970:epoch];
    return -[observed timeIntervalSinceNow];
}

- (NSString *)locationString {
    NSDictionary *loc = [rawWeather objectForKey:@"observation_location"];
    return [loc objectForKey:@"full"];
}

- (CLLocationCoordinate2D)locationCoords {
    NSDictionary *loc = [rawWeather objectForKey:@"observation_location"];
    float lat = [[loc objectForKey:@"latitude"] floatValue];
    float lon = [[loc objectForKey:@"longitude"] floatValue];
    return CLLocationCoordinate2DMake(lat, lon);
}

- (NSString *)weatherType {
    NSString *weatherString = [rawWeather objectForKey:@"weather"];
    if (!weatherString || ![weatherString length]) {
        NSLog(@"falling back to 'icon'");
        weatherString = [rawWeather objectForKey:@"icon"];
    }
    return weatherString;
}

- (float)tempc {
    return [[rawWeather objectForKey:@"temp_c"] floatValue];
}

- (float)tempf {
    return [[rawWeather objectForKey:@"temp_f"] floatValue];
}

-(float)todayMaxTempC {
    return [[[rawSimpleForecastToday objectForKey:@"high"] objectForKey:@"celsius"] floatValue];
}

-(float)todayMaxTempF {
    return [[[rawSimpleForecastToday objectForKey:@"high"] objectForKey:@"fahrenheit"] floatValue];
}

-(float)tomorrowMaxTempC {
    return [[[rawSimpleForecastTomorrow  objectForKey:@"high"] objectForKey:@"celsius"] floatValue];
}

-(float)tomorrowMaxTempF {
    return [[[rawSimpleForecastTomorrow  objectForKey:@"high"] objectForKey:@"fahrenheit"] floatValue];
}

- (int)windDegrees {
    return [[rawWeather objectForKey:@"wind_degrees"] intValue];
}

- (NSString *)windDirection {
    return [rawWeather objectForKey:@"wind_dir"];
}

- (float)windKmh {
    return [[rawWeather objectForKey:@"wind_kph"] floatValue];
}

- (int)sunriseHour {
    NSDictionary *sunrise = [rawAstronomy objectForKey:@"sunrise"];
    return [[sunrise objectForKey:@"hour"] intValue];
}

- (int)sunriseMinute {
    NSDictionary *sunrise = [rawAstronomy objectForKey:@"sunrise"];
    return [[sunrise objectForKey:@"minute"] intValue];
}

- (int)sunsetHour {
    NSDictionary *sunset = [rawAstronomy objectForKey:@"sunset"];
    return [[sunset objectForKey:@"hour"] intValue];
}

- (int)sunsetMinute {
    NSDictionary *sunrise = [rawAstronomy objectForKey:@"sunset"];
    return [[sunrise objectForKey:@"minute"] intValue];
}

-(int)weatherCodeForConditionStr:(NSString *) weatherType
{
    // converts the type into a 'code'
    if ([weatherType rangeOfString:@"Drizzle"].location != NSNotFound)
    {
        return 266;
    }
    else if ([weatherType rangeOfString:@"Light Rain"].location != NSNotFound)
    {
        return 296;
    }
    else if ([weatherType rangeOfString:@"Heavy Rain"].location != NSNotFound)
    {
        return 308;
    }
    else if ([weatherType rangeOfString:@"Rain"].location != NSNotFound)
    {
        return 302;
    }
    else if ([weatherType rangeOfString:@"Light Snow"].location != NSNotFound)
    {
        return 326;
    }
    else if ([weatherType rangeOfString:@"Heavy Snow"].location != NSNotFound)
    {
        return 338;
    }
    else if ([weatherType rangeOfString:@"Snow"].location != NSNotFound)
    {
        return 332;
    }
    else if ([weatherType rangeOfString:@"Snow Grains"].location != NSNotFound)
    {
        return 332;
    }
    else if ([weatherType rangeOfString:@"Ice Crystals"].location != NSNotFound)
    {
        return 311;
    }
    else if ([weatherType rangeOfString:@"Ice Pellets"].location != NSNotFound)
    {
        return 311;
    }
    else if ([weatherType rangeOfString:@"Hail"].location != NSNotFound)
    {
        return 1000; //todo sound
    }
    else if ([weatherType rangeOfString:@"Mist"].location != NSNotFound)
    {
        return 143;
    }
    else if ([weatherType rangeOfString:@"Fog"].location != NSNotFound)
    {
        return 248;
    }
    else if ([weatherType rangeOfString:@"Smoke"].location != NSNotFound)
    {
        return 1001; //todo sound
    }
    else if ([weatherType rangeOfString:@"Volcanic Ash"].location != NSNotFound)
    {
        return 1002; //todo sound
    }
    else if ([weatherType rangeOfString:@"Widespread Dust"].location != NSNotFound)
    {
        return 1003; //todo sound
    }
    else if ([weatherType rangeOfString:@"Sand"].location != NSNotFound)
    {
        return 1004; //todo
    }
    else if ([weatherType rangeOfString:@"Haze"].location != NSNotFound)
    {
        return 1005; //todo
    }
    else if ([weatherType rangeOfString:@"Spray"].location != NSNotFound)
    {
        return 1006; //todo
    }
    else if ([weatherType rangeOfString:@"Dust Whirls"].location != NSNotFound)
    {
        return 1007; //todo
    }
    else if ([weatherType rangeOfString:@"Sandstorm"].location != NSNotFound)
    {
        return 1008; //todo
    }
    else if ([weatherType rangeOfString:@"Low Drifting Snow"].location != NSNotFound)
    {
        return 1009; //todo
    }
    else if ([weatherType rangeOfString:@"Low Drifting Widespread Dust"].location != NSNotFound)
    {
        return 1010; //todo
    }
    else if ([weatherType rangeOfString:@"Low Drifting Sand"].location != NSNotFound)
    {
        return 1011; //todo
    }
    else if ([weatherType rangeOfString:@"Blowing Snow"].location != NSNotFound)
    {
        return 227;
    }
    else if ([weatherType rangeOfString:@"Blowing Widespread Dust"].location != NSNotFound)
    {
        return 1012; //todo
    }
    else if ([weatherType rangeOfString:@"Blowing Sand"].location != NSNotFound)
    {
        return 1013; //todo
    }
    else if ([weatherType rangeOfString:@"Rain Mist"].location != NSNotFound)
    {
        return 143;
    }
    else if ([weatherType rangeOfString:@"Rain Showers"].location != NSNotFound)
    {
        return 293;
    }
    else if ([weatherType rangeOfString:@"Snow Showers"].location != NSNotFound)
    {
        return 368;
    }
    else if ([weatherType rangeOfString:@"Ice Pellet Showers"].location != NSNotFound)
    {
        return 1014; //todo
    }
    else if ([weatherType rangeOfString:@"Hail Showers"].location != NSNotFound)
    {
        return 1015; //todo
    }
    else if ([weatherType rangeOfString:@"Small Hail Showers"].location != NSNotFound)
    {
        return 1016; //todo
    }
    else if ([weatherType rangeOfString:@"Thunderstorms and Rain"].location != NSNotFound)
    {
        return 1017; //todo
        
    }
    else if ([weatherType rangeOfString:@"Thunderstorms and Snow"].location != NSNotFound)
    {
        return 395;
    }
    else if ([weatherType rangeOfString:@"Thunderstorms and Ice Pellets"].location != NSNotFound)
    {
        return 1018; //todo
        
    }
    else if ([weatherType rangeOfString:@"Thunderstorms with Hail"].location != NSNotFound)
    {
        return 1019; //todo
        
    }
    else if ([weatherType rangeOfString:@"Thunderstorms with Small Hail"].location != NSNotFound)
    {
        return 1020; //todo
        
    }
    else if ([weatherType rangeOfString:@"Thunderstorm"].location != NSNotFound)
    {
        return 1021; //todo
        
    }
    else if ([weatherType rangeOfString:@"Freezing Drizzle"].location != NSNotFound)
    {
        return 281;
    }
    else if ([weatherType rangeOfString:@"Freezing Rain"].location != NSNotFound)
    {
        return 314; 
        
    }
    else if ([weatherType rangeOfString:@"Freezing Fog"].location != NSNotFound)
    {
        return 260;
    }
    else if ([weatherType rangeOfString:@"Patches of Fog"].location != NSNotFound)
    {
        return 248; 
        
    }
    else if ([weatherType rangeOfString:@"Shallow Fog"].location != NSNotFound)
    {
        return 248; 
        
    }
    else if ([weatherType rangeOfString:@"Overcast"].location != NSNotFound)
    {
        return 122;
    }
    else if ([weatherType rangeOfString:@"Clear"].location != NSNotFound)
    {
        return 113;
    }
    else if ([weatherType rangeOfString:@"Partly Cloudy"].location != NSNotFound)
    {
        return 116;
    }
    else if ([weatherType rangeOfString:@"Mostly Cloudy"].location != NSNotFound)
    {
        return 119;
    }
    else if ([weatherType rangeOfString:@"Scattered Clouds"].location != NSNotFound)
    {
        return 1022; //todo
        
    }
    else // unknown
    {
        return -1;
    }

}

-(int)weatherCode {
    
    NSString *weatherType = [self weatherType];
    
    return [self weatherCodeForConditionStr:weatherType];
}

- (int)weatherCodeToday {
    NSString *condition =  [rawSimpleForecastToday objectForKey:@"conditions"] ;
     return [self weatherCodeForConditionStr:condition];
}
                            
- (int)weatherCodeTomorrow {
    NSString *condition =  [rawSimpleForecastTomorrow objectForKey:@"conditions"] ;
    return [self weatherCodeForConditionStr:condition];
}
    

@end