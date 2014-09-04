//
//  ReviewCodeService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 5/18/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReviewCodeDelegate.h"

@interface ReviewCodeService : NSObject  <NSURLConnectionDelegate>
{
    id <ReviewCodeDelegate> delegate;
    NSMutableData *_responseData;
}

-(void)submitReviewCode:(NSNumber *)bedBuzzID andReviewCode:(NSString *)code  AndReturnTo:(id <ReviewCodeDelegate>)delegateClass;


@property (strong, nonatomic) id <ReviewCodeDelegate> delegate;


@end
