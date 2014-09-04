//
// Created by Matt Greenfield on 2/02/12.
// Copyright Big Paua 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define MPH_FROM_KN(KN) (1.1508 * KN)
#define KMH_FROM_KN(KN) (1.852 * KN)
#define KN_FROM_MPH(MPH) (1.0 / 1.1508 * MPH)
#define KN_FROM_KMH(KMH) (1.0 / 1.852 * KMH)
#define KMH_FROM_MPH(MPH) (KMH_FROM_KN(KN_FROM_MPH(MPH)))
#define MPH_FROM_KMH(KMH) (MPH_FROM_KN(KN_FROM_KMH(KMH)))

#define F_FROM_C(C) (9.0 / 5.0 * C + 32)
#define C_FROM_F(F) (5.0 / 9.0 * (F - 32))

@interface WUndergroundReport : NSObject

@property (nonatomic, strong) NSDictionary *response;
@property (nonatomic, strong) NSDictionary *rawWeather;
@property (nonatomic, strong) NSDictionary *rawAstronomy;
@property (nonatomic, strong) NSDictionary *rawSimpleForecastToday;
@property (nonatomic, strong) NSDictionary *rawSimpleForecastTomorrow;
@property (nonatomic, strong) NSDictionary *rawTxtToday;
@property (nonatomic, strong) NSDictionary *rawTxtTomorrow;

+ (WUndergroundReport *)fromResponse:(NSDictionary *)response;
- (NSTimeInterval)age;
- (NSString *)locationString;
- (CLLocationCoordinate2D)locationCoords;
- (NSString *)weatherType;
- (NSString *)todayTextCondition;
- (NSString *)tomorrowTextCondition;
- (float)tempc;
- (float)tempf;
- (int)windDegrees;
- (NSString *)windDirection;
- (float)windKmh;
- (int)sunriseHour;
- (int)sunriseMinute;
- (int)sunsetHour;
- (int)sunsetMinute;
-(int)weatherCode;
- (int)weatherCodeTomorrow;
- (int)weatherCodeToday;
-(float)todayMaxTempC;
-(float)todayMaxTempF;
-(float)tomorrowMaxTempC;
-(float)tomorrowMaxTempF;
@end