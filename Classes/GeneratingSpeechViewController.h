//
//  GeneratingSpeechViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/14/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechGeneratedDelegate.h"

@interface GeneratingSpeechViewController : UIViewController <SpeechGeneratedDelegate> {
	int numberOfSpeechGenerated;
	NSString *name;
}

@property (nonatomic, strong) NSString *name;

@end
