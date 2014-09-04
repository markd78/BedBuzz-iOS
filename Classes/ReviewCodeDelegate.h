//
//  ReviewCodeDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 5/18/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReviewCodeDelegate <NSObject>
-(void) reviewCodeResult:(BOOL)result;
@end
