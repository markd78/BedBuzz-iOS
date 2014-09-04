//
//  FetchRSSClipsService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/17/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "FetchRSSClipsService.h"
#import "Utilities.h"
#import "FetchRSSDelegate.h"
#import "RSSModel.h"
#import "NSData+base64Decode.h"
#import "RSSClip.h"

@implementation FetchRSSClipsService

@synthesize delegate;

-(void)getRSSClips:(NSString *)rssURL withVoiceName:(NSString *)voiceName
		AndReturnTo:(id <FetchRSSDelegate>)delegateClass
{
	self.delegate = delegateClass;

    // need to escape the rssurl
    rssURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)rssURL,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 ));
    
	NSString* url = [NSString stringWithFormat:@"%@rssFeed/GetRSSClips?rssURL=%@&voiceName=%@",[Utilities readURLConnection],rssURL, voiceName   ];

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
    NSString *responseString = [[NSString alloc] initWithData:_responseData
                                                     encoding:NSASCIIStringEncoding];
	
    NSRange textRange;
    textRange =[[responseString lowercaseString] rangeOfString:[@"<title>Status page</title>" lowercaseString]];
    
    if(textRange.location != NSNotFound)
    {
        // error
        [delegate rssClipsFetchingError];
    }
    
    // You can parse the stuff in your instance variable now
    NSArray *rssClips = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableLeaves error:nil];
    
    [self requestFinished:rssClips];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    [self connectionFailed];
}

- (void)requestFinished:(NSArray *)rssClips
{
	
	RSSModel *rssModel = [RSSModel sharedManager];
	
    rssModel.rssClips = [[NSMutableArray alloc] initWithObjects:nil];
	
	for (NSDictionary *rssClipDict in rssClips) {
		RSSClip *rssClip = [[RSSClip alloc] init];
		NSString *base64Sound = [rssClipDict objectForKey:@"base64OfSound"];
		
		rssClip.headline = [[rssClipDict objectForKey:@"title"] objectForKey:@"value"];
		rssClip.link = [[rssClipDict objectForKey:@"link"] objectForKey:@"value"];
		
		rssClip.sound  = [NSData decodeBase64WithString:base64Sound];
		
		[rssModel.rssClips addObject:rssClip];
	}
	
	[self rssClipsHaveBeenFetched];
    
    
}

-(void) rssClipsHaveBeenFetched
{
	[delegate rssClipsHaveBeenFetched];
}


@end
