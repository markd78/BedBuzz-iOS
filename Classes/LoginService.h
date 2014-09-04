//
//  LoginService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/7/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginServiceDelegate.h"

@interface LoginService : NSObject <NSURLConnectionDelegate> {
	id <LoginServiceDelegate> delegate;
    NSMutableData *_responseData;
}

-(void)logOnUserWithBedBuzzID:(NSNumber *)bedBuzzID andFBID:(NSNumber *)facebookID  AndReturnTo:(id <LoginServiceDelegate>)delegateClass;
-(void) userLoggedOn;

@property (strong, nonatomic) id <LoginServiceDelegate> delegate;

@end
