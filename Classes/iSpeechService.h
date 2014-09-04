//
//  iSpeechService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 5/22/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpeechGeneratedDelegate.h"


@interface iSpeechService : NSObject {
	
	id <SpeechGeneratedDelegate> speechGeneratedDelegate;
	NSString *conversionNumberStr;
	NSString *fileName;
}

-(void)startGenerateSpeech:(NSString *)textToConvert AndSaveToFileName:(NSString *)fileNameToSave withVoice:(NSString *)voiceName AndReturnTo:(id <SpeechGeneratedDelegate>)delegateClass;
-(void)saveSoundFromURL:(NSString *)url withVoice:(NSString *)voiceName;
@property (nonatomic, strong) NSString *fileName;
@property (strong, nonatomic) id <SpeechGeneratedDelegate> speechGeneratedDelegate;



@end
