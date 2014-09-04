//
//  MessageReadService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/4/14.
//  Copyright (c) 2014 Comantis LLC. All rights reserved.
//

#import "MessageReadService.h"
#import "MessagingServiceDelegate.h"
#import "Utilities.h"

@implementation MessageReadService
    
    -(void)markMessageRead:(NSNumber *)messageBodyID andUserID:(NSNumber *)fbUserID
    {
        NSString* url =  [[Utilities readURLConnection] stringByAppendingString:@"messages/MessageRead"];
        NSString* messageIDStr = [messageBodyID stringValue];
        NSString* userIDStr = [fbUserID stringValue];
        
        
        // Create the request.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        // Specify that it will be a POST request
        request.HTTPMethod = @"POST";
        
        // This is how we set header fields
        [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        // Convert your data and set your request's HTTPBody property
        NSString *stringData = [NSString stringWithFormat:@"messageBodyID=%@&userID=%@", messageIDStr, userIDStr];
        
        
        
        NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPBody = requestBodyData;
        
        // Create url connection and fire request
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (!conn) {
            // Release the receivedData object.
            _responseData = nil;
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
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}


    

@end
