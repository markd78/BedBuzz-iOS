//
//  MessagePlayingDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 6/6/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageVO.h"

@protocol MessagePlayingDelegate <NSObject>
-(void)messageIsBeingPlayed:(MessageVO *)message;
-(void)messageFinishedPlaying;
@end
