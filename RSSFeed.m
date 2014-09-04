//
//  RSSFeed.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "RSSFeed.h"


@implementation RSSFeed
@synthesize feedName;
@synthesize feedLink;
@synthesize voiceName;
@synthesize enabled;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:feedName forKey:@"feedName"];
	[coder encodeObject:feedLink forKey:@"feedLink"];
	[coder encodeObject:voiceName forKey:@"voiceName"];
    [coder encodeBool:enabled forKey:@"enabled"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[RSSFeed alloc] init];
    if (self != nil)
    {
        self.feedName = [coder decodeObjectForKey:@"feedName"];
		self.feedLink = [coder decodeObjectForKey:@"feedLink"];
		self.voiceName = [coder decodeObjectForKey:@"voiceName"];
        self.enabled = [coder decodeBoolForKey:@"enabled"];
    }   
    return self;
}

@end
