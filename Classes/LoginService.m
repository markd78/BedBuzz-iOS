//
//  LoginService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 10/7/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "LoginService.h"
#import "Utilities.h"
#import "LoginServiceDelegate.h"
#import "UserModel.h"
#import "Flurry.h"

@implementation LoginService
@synthesize delegate;

-(void)logOnUserWithBedBuzzID:(NSNumber *)bedBuzzID andFBID:(NSNumber *)facebookID AndReturnTo:(id <LoginServiceDelegate>)delegateClass
{
	self.delegate = delegateClass;
	
	NSString* url = [NSString stringWithFormat:@"%@userService/LogonUser?bedBuzzID=%@&fbID=%@",[Utilities readURLConnection], [bedBuzzID stringValue], [facebookID stringValue]   ];
    
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!conn) {
        // Release the receivedData object.
        _responseData = nil;
        
        [self connectionFailed];
    }
    
    if ([bedBuzzID intValue] == -1)
    {
        [Flurry logEvent:@"CREATED_USER"];
    }
}

-(void)connectionFailed
{
    // The request has failed for some reason!
    // Check the error var
    
    UserModel *userModel = [UserModel userModel];
    userModel.userSettings.isOfflineMode = YES;
    
    [self userLoggedOn];
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

- (void)requestFinished:(NSDictionary *)userDict
{
	
	BOOL isPaidUser = [[userDict objectForKey:@"isPaidIOSSubscriptionUser"] boolValue];
	
    BOOL isFirstTimeLoginWithFBID = [[userDict objectForKey:@"isFirstTimeLogginOnWithFBID"] boolValue];
    
	NSNumber *bedBuzzID = [userDict objectForKey:@"bedBuzzID"];
	NSString *dateOfSubscription =  [userDict objectForKey:@"isIOSPaidSubscriberThrough"];
    
	UserModel *userModel = [UserModel userModel];
    userModel.userSettings.isOfflineMode = NO;
	userModel.userSettings.isPaidUser = isPaidUser;
	userModel.userSettings.bedBuzzID = bedBuzzID;
    
    // get the subscription date
    [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
	
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"MMM dd, yyyy h:mm:ss aaa"];
    
	userModel.userSettings.subscriberUntilDate = [dateFormatter dateFromString:dateOfSubscription];
    
    if (isFirstTimeLoginWithFBID)
    {
        userModel.userSettings.sendMessageCredits = 5;
        [Flurry logEvent:@"CREATED_USER_WITH_FACEBOOK"];
    }
    
	[userModel saveUserSettings];
	
	[self userLoggedOn];
}

-(void) userLoggedOn
{
	[delegate userLoggedIn];
}



@end
