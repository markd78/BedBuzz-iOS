//
//  AddMessageService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/4/14.
//  Copyright (c) 2014 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessagingServiceDelegate.h"
#import "MessageVO.h"

@interface AddMessageService : NSObject <NSURLConnectionDelegate>
{
     NSMutableData *_responseData;
	id <MessagingServiceDelegate> delegate;
}


- (void)sendMessage:(MessageVO *)message
		AndReturnTo:(id <MessagingServiceDelegate>)delegateClass;

@property (strong, nonatomic) id <MessagingServiceDelegate> delegate;


@end
