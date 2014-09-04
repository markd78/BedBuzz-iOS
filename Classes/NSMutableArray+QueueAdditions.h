//
//  NSMutableArray+QueueAdditions.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end

