//
//  AlarmsModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSModel : NSObject {
	
	NSMutableArray *rssClips;
	NSMutableArray *rssFeeds;
    NSMutableDictionary *webviewDict;
}

-(void)saveRSSFeeds;
-(void)loadRSSFeeds;
-(void)storeWebView:(UIWebView *)webview ForURL:(NSString *)url;

@property (nonatomic, strong) NSMutableArray *rssClips;
@property (nonatomic, strong) NSMutableArray *rssFeeds;
@property (nonatomic, strong) NSMutableDictionary *webviewDict;
+ (id)sharedManager;
@end
