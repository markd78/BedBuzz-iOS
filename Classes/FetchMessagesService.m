//
//  FetchMessagesService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/3/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "FetchMessagesService.h"
#import "Utilities.h"
#import "MessageVO.h"
#import "MessagingModel.h"
#import "FetchMessagesDelegate.h"
#import "NSData+base64Decode.h"

@implementation FetchMessagesService
@synthesize delegate;

- (void)fetchUnreadMessages:(NSNumber *)userID
     ThatAreOlderThanOneDay:(BOOL)isOlderThanOneDay
		AndReturnTo:(id <FetchMessagesDelegate>)delegateClass
{
	self.delegate = delegateClass;
	
	NSString *userIDStr = [userID stringValue];
	
	NSString* url = [NSString stringWithFormat:@"%@messages/GetMessages?userID=%@&getMessageOverOneDayOld=%d",[Utilities readURLConnection],userIDStr, isOlderThanOneDay   ];
    
	
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!conn) {
        // Release the receivedData object.
        _responseData = nil;
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
    NSArray *messages = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableLeaves error:nil];
    
    [self requestFinished:messages];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    [self connectionFailed];
}

- (void)requestFinished:(NSArray *)messages
{
	
	MessagingModel *messagingModel = [MessagingModel sharedManager];
	
	messagingModel.messagesToPlay = [[NSMutableArray alloc] initWithObjects:nil];
	
	for (NSDictionary *messageDict in messages) {
		MessageVO *message = [[MessageVO alloc] init];
		NSString *base64Sound = [messageDict objectForKey:@"soundBase64String"];
		
		message.voiceName = [messageDict objectForKey:@"voiceName"];
		message.messageText = [messageDict objectForKey:@"voiceText"];
		
		message.sound  = [NSData decodeBase64WithString:base64Sound];
		message.isRead =  [[messageDict objectForKey:@"isRead"] boolValue];
		message.messageBodyID = [[messageDict objectForKey:@"key"] objectForKey:@"id"];
        message.senderID =  [messageDict objectForKey:@"messageFromFBID"];
		
		[messagingModel.messagesToPlay addObject:message];
	}
	
	[self messagesHaveBeenFetched];
}

-(void) messagesHaveBeenFetched
{
	[delegate messagesHaveBeenFetched];
}

@end
