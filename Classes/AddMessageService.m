//
//  AddMessageService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/4/14.
//  Copyright (c) 2014 Comantis LLC. All rights reserved.
//

#import "AddMessageService.h"

#import "Utilities.h"
#import "MessageVO.h"
#import "MessagingServiceDelegate.h"
#import "MessagingModel.h"
#import "FacebookUser.h"

@implementation AddMessageService

@synthesize delegate;

// From: http://www.cocoadev.com/index.pl?BaseSixtyFour

+ (NSString*)base64forData:(NSData*)theData {
	
	const uint8_t* input = (const uint8_t*)[theData bytes];
	NSInteger length = [theData length];
	
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
	
	NSInteger i,i2;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
		for (i2=0; i2<3; i2++) {
            value <<= 8;
            if (i+i2 < length) {
                value |= (0xFF & input[i+i2]);
            }
        }
		
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
	
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (void)sendMessage:(MessageVO *)message
		AndReturnTo:(id <MessagingServiceDelegate>)delegateClass
{
	
	[self setDelegate:delegateClass];
	
	NSString* url =  [[Utilities readURLConnection] stringByAppendingString:@"messages/AddMessageWithFormat"];
	NSString *senderIDStr = [ message.senderID stringValue];
	
	MessagingModel *messagingModel = [MessagingModel sharedManager];
	
	NSString *userArrStr = @"[";
	
	// CONVERT target array into string
	for (int i=0; i<[messagingModel.targetFriends count ]; i++)
	{
		FacebookUser *fbUser = [messagingModel.targetFriends objectAtIndex:i];
		NSString *userIDStr = [fbUser.uid stringValue];
		userArrStr = [userArrStr stringByAppendingString:userIDStr];
		
		if (i + 1 != [messagingModel.targetFriends count ])
		{
			userArrStr = [userArrStr stringByAppendingString:@","];
		}
		
	}
	
	userArrStr = [userArrStr stringByAppendingString:@"]"];
	
	
    
    
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSMutableString *stringData = [NSMutableString stringWithFormat:@"receiverIDs=%@&senderID=%@&voiceName=%@", userArrStr, senderIDStr,message.voiceName];
    if (message.sound!=nil)
    {
        [stringData appendString:[NSString stringWithFormat:@"&format=aac"]];
        [stringData appendString:[NSString stringWithFormat:@"&soundBase64String=%@",[AddMessageService base64forData:message.sound]  ]];
    }
    else {
        [stringData appendString:[NSString stringWithFormat:@"&format=text"]];
        
    }
    
    
    
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
    
    // Use when fetching text data
    NSString *responseString = [[NSString alloc] initWithData:_responseData
                                                     encoding:NSASCIIStringEncoding];
    
    	[delegate messageServiceResult:responseString];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}



@end
