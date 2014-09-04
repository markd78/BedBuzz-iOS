//
//  RSSClipBeingPlayed.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/30/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RSSClipBeingPlayedDelegate

-(void)RSSClipBeingPlayed:(NSString *) url;
-(void)RSSClipEnded;

@end
