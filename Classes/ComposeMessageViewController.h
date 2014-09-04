//
//  ComposeMessageViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/26/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVO.h"
#import "MessagingServiceDelegate.h"
#import "SpeechGeneratedDelegate.h"
#import "ComposeMessageViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "RecordingCountdownFinishedDelegate.h"

@class ComposeMessageMicrophoneController;

@interface ComposeMessageViewController : UIViewController <MessagingServiceDelegate, UITextViewDelegate, SpeechGeneratedDelegate, RecordingCountdownFinishedDelegate> {
	IBOutlet UIScrollView* toListScrollView;
	IBOutlet UITextView* messageBody;
	IBOutlet UISegmentedControl* segmentedControl;
    IBOutlet UILabel* numberOfMessageCreditsLeftLbl;
    IBOutlet UILabel* inviteLbl;
    IBOutlet UILabel* creditsRemainingLbl;
    IBOutlet UIButton* saveMessageBtn;
     IBOutlet UIButton* testMessageBtn;
    IBOutlet UIButton* testRecordingBtn;
    IBOutlet UIActivityIndicatorView* pleaseWaitSpinner;
    IBOutlet UILabel* pleaseWaitLbl;
    IBOutlet UILabel* infoLbl;
    IBOutlet UILabel* voiceLbl;
    IBOutlet UISegmentedControl* messageTypeSegmentedControl;
    IBOutlet UIButton* buyMoreCreditsBtn;
    IBOutlet UIButton* recordBtn;
     IBOutlet UIButton* stopBtn;
    IBOutlet UILabel* displayedMessageLabel;
    IBOutlet UILabel* countdownLbl;
    IBOutlet UIProgressView* micLevel;
    
    IBOutlet ComposeMessageMicrophoneController *controller;
	MessageVO* messageComposing;
	BOOL hasRecorded;
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
	
	CFStringRef					recordFilePath;	

    BOOL                        countDownTimerActive;
    
    int recordingCountDownNumber;
    IBOutlet UILabel* timeRemaingLbl;
    
    NSTimer *countdownTimer;
     NSTimer *micLevelTimer;
    int secondsLeft;
    float translatedMicValue;

}




@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) UITextView *messageBody;
	@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
-(IBAction) segmentedControlIndexChanged;
-(IBAction) messageTypeSegmentedControlIndexChanged;
- (IBAction)testMessage;
- (IBAction)saveMessage;
- (IBAction)recordBtnPressed;
- (IBAction)stopRecordBtnPressed;

- (IBAction)buyMoreCreditsClicked;
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField;
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
-(void)popOverWasClosed;
-(void)startRecording;
-(void) playRecording;
-(void) stopRecording;
-(void) recordingCountdownFinished;
@end
