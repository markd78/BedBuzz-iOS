//
//  FetchFacebookMessageDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 11/26/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchFacebookMessageDelegate <NSObject>
-(void) facebookMessageHasBeenFetched:(NSString *)message;
@end
