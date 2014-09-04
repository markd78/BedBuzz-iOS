//
//  MessageReadService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/4/14.
//  Copyright (c) 2014 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagingServiceDelegate.h"
#import "MessageVO.h"

@interface MessageReadService : NSObject  <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
	id <MessagingServiceDelegate> delegate;
}

-(void)markMessageRead:(NSNumber *)messageBodyID andUserID:(NSNumber *)fbUserID;

@end
