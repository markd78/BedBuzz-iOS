//
//  NonRenewSubscriptionService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 12/29/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NonRenewSubscriptionService : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}
- (void)subscribeUser:(NSNumber *)fbUserID
    ForThisManyMonths:(NSNumber *)months;
@end

