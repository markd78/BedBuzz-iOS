//
//  MessagingModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RSSModel.h"

static RSSModel *sharedMyManager = nil;

@implementation RSSModel

@synthesize rssClips;
@synthesize rssFeeds;
@synthesize webviewDict;

#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedMyManager == nil)
			sharedMyManager = [[super allocWithZone:NULL] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	rssClips = [[NSMutableArray alloc] initWithObjects:nil];
	rssFeeds = [[NSMutableArray alloc] initWithObjects:nil];
    
	return self;
}

-(void)saveRSSFeeds {
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[self rssFeeds]] forKey:@"kFeeds"];
	[[NSUserDefaults standardUserDefaults]  synchronize];
	
		
	}

-(void)storeWebView:(UIWebView *)webview ForURL:(NSString *)url
{
    [webviewDict setValue:webview forKey:url]; 
}

-(void)loadRSSFeeds {
	
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	
	
	NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"kFeeds"];
	NSArray *oldSavedArray;
	BOOL feedsRetreived = NO;
	
	if (dataRepresentingSavedArray != nil)
	{
		
		@try { 
			oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
			feedsRetreived = YES;
		}
		@catch (NSException *exception) {
			NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
		}
		
        
	}
	
	if (feedsRetreived)
		[self setRssFeeds:[[NSMutableArray alloc] initWithArray:oldSavedArray]];
	else
		[self setRssFeeds:[[NSMutableArray alloc] init]];
}


@end
