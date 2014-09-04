//
//  GetUnreadMessageCountService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 12/1/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetUnreadMessagesCountDelegate.h"

@interface GetUnreadMessageCountService : NSObject <NSURLConnectionDelegate>
{
id <GetUnreadMessagesCountDelegate> delegate;
        NSMutableData *_responseData;
}


- (void)fetchUnreadMessagesCount:(NSNumber *)userID
				AndReturnTo:(id <GetUnreadMessagesCountDelegate>)delegateClass;

@property (strong, nonatomic) id <GetUnreadMessagesCountDelegate> delegate;


@end
