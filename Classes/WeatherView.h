//
//  WeatherView.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherSpeechGeneratedDelegate.h"


@interface WeatherView : UIView <WeatherSpeechGeneratedDelegate> {

    
    
}

-(void)weatherSpeechGenerated;

@end
