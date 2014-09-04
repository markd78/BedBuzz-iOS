//
//  RSSClip.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/17/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSSClip : NSObject {
	NSString *headline;
	NSString *link;
	NSData *sound;
}

@property (nonatomic, strong) NSString *headline;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSData *sound;
@end
