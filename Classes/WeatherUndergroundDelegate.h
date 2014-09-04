//
//  ReviewCodeDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 5/18/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherUndergroundDelegate <NSObject>
-(void) weatherLoaded:(NSDictionary *)dict;
@end
