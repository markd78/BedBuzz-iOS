//
//  NSMutableArray+QueueAdditions.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (NSDataAdditions)
+ (NSData *)decodeBase64WithString:(NSString *)strBase64;
@end

