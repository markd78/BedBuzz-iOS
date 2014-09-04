//
//  UpdateUsersFacebookIDService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 11/30/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateUsersFacebookIDService : NSObject <NSURLConnectionDelegate>
{
     NSMutableData *_responseData;
}
-(void)updateUsersFacebookID:(NSNumber *)bedBuzzID andFBID:(NSNumber *)facebookID;
@end
