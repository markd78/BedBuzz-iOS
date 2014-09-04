//
//  FacebookGotUserNameDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/18/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FacebookGotUserNameDelegate
-(void) facebookGotUserName:(NSString*)name andID:(NSString*)facebookID ;
@end
