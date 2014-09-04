//
//  FetchRSSDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/17/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FetchRSSDelegate
-(void) rssClipsHaveBeenFetched;
-(void) rssClipsFetchingError;
@end
