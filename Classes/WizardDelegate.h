//
//  WizardDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WizardDelegate <NSObject>

-(void) showNextScreen:(int)screen FromCurrentScreen:(int)currentScreen;
@end
