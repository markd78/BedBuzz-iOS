//
//  AmazonPoly.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/29/17.
//  Copyright © 2017 Comantis LLC. All rights reserved.
//

#import "AmazonPoly.h"
#import "AWSPolly.h"


@implementation AmazonPoly

-(void)saveSoundFromURL:(NSString *)textToConvert withVoice:(NSString *)voiceName {
    
    if (textToConvert == nil)
    {
        // just return
        [self.speechGeneratedDelegate speechGenerated];
        return;
    }
    
    AWSPollySynthesizeSpeechURLBuilderRequest *request = [[AWSPollySynthesizeSpeechURLBuilderRequest alloc] init];
    
    // We expect the output in MP3 format
    request.outputFormat = AWSPollyOutputFormatMp3;
    
    // Use the voice we selected earlier using picker to synthesize
    request.voiceId = AWSPollyVoiceIdEmma;
    
    request.text = textToConvert;
    
    // Create an task to synthesize speech using the given synthesis input
    AWSTask *builder = [[AWSPollySynthesizeSpeechURLBuilder defaultPollySynthesizeSpeechURLBuilder] getPreSignedURL:request];
    
    
    // Request the URL for synthesis result
    [[builder continueWithSuccessBlock:^id(AWSTask *task) {
        
        // The result of getPresignedURL task is NSURL.
        // Again, we ignore the errors in the example.
        NSURL* url = task.result;
        
        // Try playing the data using the system AVAudioPlayer
        [self saveSoundToDisk:url];
        
        return nil;
    }
     ] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Error: %@", task.error);
        }
        return nil;
    }];
    
}


-(void)saveSoundToDisk:(NSURL* )url
{
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
    [_speechGeneratedDelegate speechGenerated];
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
