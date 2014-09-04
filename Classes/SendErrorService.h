//
//  SendErrorService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/26/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendErrorService : NSObject <NSURLConnectionDelegate>
{
     NSMutableData *_responseData;
}

-(void)sendErrorMessage:(NSString *)errorMsg;


@end
