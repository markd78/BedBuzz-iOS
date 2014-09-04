//
//  WeatherUndergroundService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/4/14.
//  Copyright (c) 2014 Comantis LLC. All rights reserved.
//

#import "WeatherUndergroundService.h"
#import "Utilities.h"
#import "LoginServiceDelegate.h"
#import "UserModel.h"
#import "Flurry.h"

#import <CoreLocation/CoreLocation.h>

#define FEATURES       @"conditions/astronomy/forecast"
#define API_KEY        @"37832a4590eac49d"
@implementation WeatherUndergroundService
@synthesize delegate;

-(void)getWeatherForecastWithDelegate:(id<WeatherUndergroundDelegate>) delegateClass ForLocation:(CLLocationCoordinate2D)coordinate
{
	self.delegate = delegateClass;
	
    // new request
    NSString *url = [NSString
                     stringWithFormat:@"http://api.wunderground.com/api/%@/%@/q/%f,%f.json",
                     API_KEY, FEATURES,
                     coordinate.latitude,
                     coordinate.longitude];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!conn) {
        // Release the receivedData object.
        _responseData = nil;
        
        [self connectionFailed];
    }
    
}

-(void)connectionFailed
{
    // The request has failed for some reason!
    // Check the error var
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableLeaves error:nil];
    
    [self requestFinished:dic];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    [self connectionFailed];
}

- (void)requestFinished:(NSDictionary *)weatherDict
{
	
	[delegate weatherLoaded:weatherDict];
}




@end
