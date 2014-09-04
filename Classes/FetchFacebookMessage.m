//
//  FetchFacebookMessage.m
//  SpeakAlarm
//
//  Created by Mark Davies on 11/26/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "FetchFacebookMessage.h"
#import "FetchFacebookMessageDelegate.h"
#import "Utilities.h"

@implementation FetchFacebookMessage

@synthesize delegate;

-(void)getFacebookMessageAndReturnTo:(id <FetchFacebookMessageDelegate>)delegateClass
{
    self.delegate = delegateClass;
    
	NSString* url = [NSString stringWithFormat:@"%@bedBuzz/GetFBMessage",[Utilities readURLConnection]  ];
    
    self.delegate = delegateClass;
	
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
    
    NSString *responseString = [[NSString alloc] initWithData:_responseData
                                                     encoding:NSASCIIStringEncoding];
    [delegate facebookMessageHasBeenFetched:responseString];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}


@end
