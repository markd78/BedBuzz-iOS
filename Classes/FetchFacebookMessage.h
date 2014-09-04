//
//  FetchFacebookMessage.h
//  SpeakAlarm
//
//  Created by Mark Davies on 11/26/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchFacebookMessageDelegate.h"

@interface FetchFacebookMessage : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    
    id <FetchFacebookMessageDelegate> delegate;
}


-(void)getFacebookMessageAndReturnTo:(id <FetchFacebookMessageDelegate>)delegateClass;

@property (strong, nonatomic) id <FetchFacebookMessageDelegate> delegate;
@end
