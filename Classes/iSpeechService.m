//
//  iSpeechService.m
//  SpeakAlarm
//
//  Created by Mark Davies on 5/22/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "iSpeechService.h"


@implementation iSpeechService
@synthesize fileName;
@synthesize speechGeneratedDelegate;

-(void)saveSoundFromURL:(NSString *)textToConvert withVoice:(NSString *)voiceName {
	
	NSString *iSpeechURL = [NSString stringWithFormat:@"http://api.ispeech.org/api/rest?apikey=a732a504a6def0d66a657c0c362b2a48&action=convert&voice=%@&text=",voiceName];
	
    if (textToConvert == nil)
    {
        // just return
        [speechGeneratedDelegate speechGenerated];
        return;
    }
    
	NSURL *url = [NSURL URLWithString:[iSpeechURL stringByAppendingString:textToConvert]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
	NSURLResponse *responce = nil;
	NSError *err = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&responce error:&err];
    NSLog(@"data=%@  responce MIMEType = %@",data,[responce MIMEType] );	
	if (data == nil) {
		NSLog(@"sound not created");
	}
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *savePath = [documentsDirectory stringByAppendingPathComponent:self.fileName];
	
	[data writeToFile:savePath atomically:NO];   
	
    NSLog(@"Saving to %@    ",savePath);
    
	// we are done baby, lets tell the delegateclass
	[speechGeneratedDelegate speechGenerated];
}

-(void)startGenerateSpeech:(NSString *)textToConvert AndSaveToFileName:(NSString *)fileNameToSave withVoice:(NSString *)voiceName AndReturnTo:(id <SpeechGeneratedDelegate>)delegateClass;
{
	
	self.fileName = fileNameToSave;
	self.speechGeneratedDelegate = delegateClass;
	NSString* escapedUrlString =
	[textToConvert stringByAddingPercentEscapesUsingEncoding:
	 NSASCIIStringEncoding];
	
	[self saveSoundFromURL:escapedUrlString withVoice:voiceName];
}





@end
