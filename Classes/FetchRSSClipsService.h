//
//  FetchRSSClipsService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/17/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchRSSDelegate.h"

@interface FetchRSSClipsService : NSObject <NSURLConnectionDelegate> {
	id <FetchRSSDelegate> delegate;
    NSMutableData *_responseData;
}


-(void)getRSSClips:(NSString *)rssURL withVoiceName:(NSString *)voiceName AndReturnTo:(id <FetchRSSDelegate>)delegateClass;
-(void) rssClipsHaveBeenFetched;

@property (strong, nonatomic) id <FetchRSSDelegate> delegate;
@end
