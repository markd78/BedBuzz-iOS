//
//  GetUnreadMessageCountService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 12/1/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "GetUnreadMessageCountService.h"
#import "GetUnreadMessagesCountDelegate.h"
#import "Utilities.h"

@implementation GetUnreadMessageCountService
@synthesize delegate;

- (void)fetchUnreadMessagesCount:(NSNumber *)userID
                     AndReturnTo:(id <GetUnreadMessagesCountDelegate>)delegateClass;
{
	self.delegate = delegateClass;
    
    if ([userID isEqualToNumber:[NSNumber numberWithInt:-1]])
    {
        [delegate messageCountRefreshed:0];
    }
    else {
        NSString *userIDStr = [userID stringValue];
        
        NSString* url =  [[Utilities readURLConnection] stringByAppendingString:@"messages/GetUnreadMessageCount?userID="];
        url =  [url stringByAppendingString:userIDStr];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
        
        [request setHTTPMethod:@"GET"];
        
        NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (!conn) {
            // Release the receivedData object.
            _responseData = nil;
        }
        
    }
	
	
	
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
    
    // Use when fetching text data
    NSString *responseString = [[NSString alloc] initWithData:_responseData
                                                     encoding:NSASCIIStringEncoding];
    
	
    
    [delegate messageCountRefreshed:[responseString intValue]];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}



@end
