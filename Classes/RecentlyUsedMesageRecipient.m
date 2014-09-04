//
//  RecentlyUsedMesageReceipient.m
//  SpeakAlarm
//
//  Created by Mark Davies on 11/4/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "RecentlyUsedMesageRecipient.h"

@implementation RecentlyUsedMesageRecipient
@synthesize fbID;
@synthesize dateUsed;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:fbID  forKey:@"fbID"];
	[coder encodeObject:dateUsed forKey:@"dateUsed"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[RecentlyUsedMesageRecipient alloc] init];
    if (self != nil)
    {
		self.fbID = [coder decodeObjectForKey:@"fbID"];
        self.dateUsed = [coder decodeObjectForKey:@"dateUsed"];
    }
    
    return self;

}

@end
