//
//  FetchMessagesService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/3/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchMessagesDelegate.h"

@interface FetchMessagesService : NSObject <NSURLConnectionDelegate> {
	id <FetchMessagesDelegate> delegate;
    NSMutableData *_responseData;
}


- (void)fetchUnreadMessages:(NSNumber *)userID
     ThatAreOlderThanOneDay:(BOOL)isOlderThanOneDay
                AndReturnTo:(id <FetchMessagesDelegate>)delegateClass;
-(void) messagesHaveBeenFetched;

@property (strong, nonatomic) id <FetchMessagesDelegate> delegate;


@end
