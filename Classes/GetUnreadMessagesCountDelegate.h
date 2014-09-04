//
//  GetUnreadMessagesCountDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 12/1/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetUnreadMessagesCountDelegate <NSObject>
-(void) messageCountRefreshed:(int)numberOfMessages;
@end
