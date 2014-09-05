//
//  ComposeMessageViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/26/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "ComposeMessageViewController.h"
#import "MessagingModel.h"
#import "FacebookUser.h"
#import "MessageVO.h"
#import "AddMessageService.h"
#import "UserModel.h"
#import "iSpeechService.h"
#import "iToast.h"
#import "SoundDirector.h"
#import "BuyViewController.h"
#import "SpeakAlarmAppDelegate.h"
#import "StoreKitModel.h"
#import "FacebookModel.h"
#import <AudioToolbox/AudioServices.h>

@implementation ComposeMessageViewController
@synthesize segmentedControl;
@synthesize audioRecorder;
@synthesize messageBody;


#define MAX_LENGTH_OF_MESSAGE 600

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

-(void)setControlVisibility
{
    [countdownLbl setHidden:YES];
     [micLevel setHidden:YES];
    [timeRemaingLbl setHidden:YES];
    
    if (messageTypeSegmentedControl.selectedSegmentIndex == 0)
    {
        [segmentedControl setHidden:YES];
        [recordBtn setHidden:NO];
        [stopBtn setHidden:YES];
         [voiceLbl setHidden:YES];
        [displayedMessageLabel setHidden:NO];
        [testMessageBtn setHidden:YES];
        [testRecordingBtn setHidden:NO];
        [messageBody setFrame:CGRectMake(messageBody.frame.origin.x, messageBody.frame.origin.y+95, messageBody.frame.size.width, messageBody.frame.size.height)];
        
        if (hasRecorded)
        {
            testRecordingBtn.enabled = YES;
            saveMessageBtn.enabled = YES;
        }
        else {
            testRecordingBtn.enabled = NO;
            saveMessageBtn.enabled = NO;
        }
    }
    else {
        [segmentedControl setHidden:NO];
        [voiceLbl setHidden:NO];
        [recordBtn setHidden:YES];
        [stopBtn setHidden:YES];
        [displayedMessageLabel setHidden:YES];
        [testMessageBtn setHidden:NO];
        [testRecordingBtn setHidden:YES];
        [messageBody setFrame:CGRectMake(messageBody.frame.origin.x, messageBody.frame.origin.y-95, messageBody.frame.size.width, messageBody.frame.size.height)];
        
        if (messageBody.text.length == 0)
        {
            testMessageBtn.enabled = NO;
            saveMessageBtn.enabled = NO;
        }
    }
    
}


- (void)setupHorizontalScrollView
{
    // populate the toListScrollView
	MessagingModel *messagingModel = [MessagingModel sharedManager];
    
    
    toListScrollView.delegate = self;
    
    // [toListScrollView setBackgroundColor:[UIColor blackColor]];
    [toListScrollView setCanCancelContentTouches:NO];
    
    toListScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    toListScrollView.clipsToBounds = NO;
    toListScrollView.scrollEnabled = YES;
    
    CGFloat cx = 0;
    
    for (FacebookUser *fbUser in messagingModel.targetFriends)
	{
		
		NSURL * imageURL = [NSURL URLWithString:fbUser.picSmallURL];
		NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
		UIImage *tableImage = [[UIImage alloc] initWithData:imageData]; 
        
		UIImageView *tempImageView = 
        [[UIImageView alloc] initWithImage:tableImage];
        
        CGRect rect = tempImageView.frame;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        tempImageView.frame = rect;
        
        [toListScrollView addSubview:tempImageView];
        
        cx += tempImageView.frame.size.width+2;
        
        inviteLbl.hidden = YES;
        infoLbl.hidden = NO;
        if (!fbUser.isBedBuzzUser)
        {
            inviteLbl.hidden = NO;
            infoLbl.hidden = YES;
        }
        
	}
}

-(void)viewWillAppear:(BOOL)animated
{
    hasRecorded = NO;
     countDownTimerActive = NO;
    self.navigationItem.title = @"Compose message";
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.isPaidUser)
    {
        numberOfMessageCreditsLeftLbl.hidden = YES;
        creditsRemainingLbl.hidden = YES;
        [saveMessageBtn setHidden:NO];
        [buyMoreCreditsBtn setHidden:YES];
    }
    else
    {
        numberOfMessageCreditsLeftLbl.text =  [NSString stringWithFormat:@"%ld", (long)userModel.userSettings.sendMessageCredits];
        
        if (userModel.userSettings.sendMessageCredits == 0)
        {
            [saveMessageBtn setHidden:YES];
            [buyMoreCreditsBtn setHidden:NO];
        }
        else
        {
            [saveMessageBtn setHidden:NO];
            [buyMoreCreditsBtn setHidden:YES];
        }
    }
    
    if (messageBody.text.length == 0)
    {
        testMessageBtn.enabled = NO;
        saveMessageBtn.enabled = NO;
    }
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UserModel *userModel = [UserModel userModel];
    
    [messageBody setText:@"Good morning!"];
    
    
    if (!userModel.userSettings.heardComposeMessageHelp)
    {
        SoundDirector *sd = [SoundDirector soundDirector];
        [sd sayTypeMessageHelp];
        
        userModel.userSettings.heardComposeMessageHelp = YES;
        [userModel saveUserSettings];
    }
    
	messageComposing = [[MessageVO alloc] init];
	messageComposing.senderID = userModel.userSettings.fbID;
	messageComposing.voiceName = @"usenglishfemale1";
     messageComposing.messageText = @"Good morning!";
	pleaseWaitLbl.hidden = YES;
    pleaseWaitSpinner.hidden = YES;
    
    [self setControlVisibility];
    
    // give textbox focus
    //[messageBody becomeFirstResponder];
    
    [self setupHorizontalScrollView];
    
    
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    
    if (countdownTimer!=nil && countDownTimerActive)
    {
        [countdownTimer invalidate];
        countDownTimerActive = NO;
    }
}

-(IBAction) segmentedControlIndexChanged{
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0:
			// US FEMALE
			messageComposing.voiceName = @"usenglishfemale1";
			break;
		case 1:
			// US MALE
			messageComposing.voiceName = @"usenglishmale1";
			break;
			
		default:
			// UK FEMALE
			messageComposing.voiceName = @"ukenglishfemale1";
			break;
	}
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 0)
    {
        saveMessageBtn.enabled = YES;
    }
    
    if (textField.text.length >= MAX_LENGTH_OF_MESSAGE && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {return YES;}
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	messageComposing.messageText = messageBody.text;
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (txtView.text.length > 0)
    {
        saveMessageBtn.enabled = YES;
        testMessageBtn.enabled = YES;
    }
    
    if (txtView.text.length >= MAX_LENGTH_OF_MESSAGE && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
	
    [txtView resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([messageBody isFirstResponder] && [touch view] != messageBody) {
        [messageBody resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(BOOL) textFieldShouldReturn:(UITextField *)theTextField {
	
	[messageBody resignFirstResponder];
	
	return YES;
}

-(void)hidePleaseWait
{
    pleaseWaitLbl.hidden = YES;
    pleaseWaitSpinner.hidden = YES;
    testMessageBtn.enabled = YES;
    saveMessageBtn.enabled = YES;
    
}

-(void)showPleaseWait
{
    pleaseWaitLbl.hidden = NO;
    pleaseWaitSpinner.hidden = NO;
    testMessageBtn.enabled = NO;
    saveMessageBtn.enabled = NO;
}

-(void)recordTimerStart
{
    countDownTimerActive = YES;
    secondsLeft = 20;
    countdownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [timeRemaingLbl setHidden:NO];
    
}


-(void)micLevelTimerStart
{
    micLevelTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(micLevelTimerFired) userInfo:nil repeats:YES];
   
}

-(void)micLevelTimerStop
{
    if( micLevelTimer!=nil && [micLevelTimer isValid])
    {
        [micLevelTimer invalidate];
    }
}

-(void)micLevelTimerFired
{
   
    
    [self performSelectorInBackground:@selector(updateLevel:) withObject:nil];
}

- (void)updateLevel:(id)object
{
    [audioRecorder updateMeters];
    float averagePowerFloat = [audioRecorder averagePowerForChannel:0];
    translatedMicValue =  (80+averagePowerFloat )/100;
    //NSLog(@"translatedMicValue =  %f averagePowerFloat = %f ",translatedMicValue,averagePowerFloat);
    [micLevel setProgress:translatedMicValue];
 }

-(void)timerFired
{
    if(secondsLeft>=0)
    {
        secondsLeft--;
        [timeRemaingLbl setText:[NSString stringWithFormat:@"Seconds left: %d secs",secondsLeft]];
    }
    else {
        
        [self stopRecording];
        [timeRemaingLbl setHidden:YES];
        [testRecordingBtn setEnabled:YES];
        [timeRemaingLbl setHidden:YES];
        [countdownLbl setHidden:YES];
    }
}

- (IBAction)testMessage {
	
    messageComposing.messageText = messageBody.text;
    
    if (messageTypeSegmentedControl.selectedSegmentIndex == 0)
    {
        // play the reocrded message
        SoundDirector *sd = [SoundDirector soundDirector];
        [sd playRecordedMessage];
        saveMessageBtn.enabled = YES;
    }
    else 
    {
        SoundDirector *sd = [SoundDirector soundDirector];
        [sd stopSounds];
        
        if ([messageBody isFirstResponder])
        {
            [messageBody resignFirstResponder];
        }
        
        [self showPleaseWait];
        
        if (messageComposing.messageText != nil && ![messageComposing.messageText isEqualToString:@""])
        {
            // generate the sounds	
            iSpeechService *iSpeechService1 = [[iSpeechService alloc] init];
            [iSpeechService1 startGenerateSpeech:messageComposing.messageText AndSaveToFileName:@"messageTest.mp3" withVoice:messageComposing.voiceName AndReturnTo:self];
        }
    }
}

-(void)popOverWasClosed
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)buyMoreCreditsClicked {
    StoreKitModel *skModel = [StoreKitModel sharedManager];
    // GO TO Buy Page
	BuyViewController *buyViewController = [[BuyViewController alloc] initWithNibName:@"BuyView" bundle:[NSBundle mainBundle] AndProductID:skModel.productMessagesID];
    
	[self.navigationController pushViewController:buyViewController animated:YES ]; // "Pushing the controller on the screen" 
    
}

- (IBAction)testRecordBtnPressed {
    //[testRecordingBtn setEnabled:NO];
    [saveMessageBtn setEnabled:YES];
    
    [self playRecording];
}

- (IBAction)stopRecordBtnPressed {
    [testRecordingBtn setEnabled:YES];
    [stopBtn setHidden:YES];
    [recordBtn setHidden:NO];
    [countdownLbl setHidden:YES];
    [recordBtn setTitle:@"Re-Record" forState:UIControlStateNormal];
    [saveMessageBtn setEnabled:YES];
    [micLevel setHidden:YES];
    [timeRemaingLbl setHidden:YES];
    
    [self stopRecording];
}

- (IBAction)recordBtnPressed {
     [recordBtn setHidden:YES];
    [stopBtn setHidden:NO];
     [stopBtn setEnabled:NO];
    [countdownLbl setHidden:NO];
   
    [saveMessageBtn setEnabled:NO];
    [testRecordingBtn setEnabled:NO];
    
    
    recordingCountDownNumber = 3;
    
    [countdownLbl setText:@"Recording in 3..."];
    
    SoundDirector *sd = [SoundDirector soundDirector];
    [sd playRecordedCountdownAndReturnTo:self];
    
   
}


-(void)recordingCountdownFinished
{
    
    
    [countdownLbl setText:[NSString stringWithFormat:@"Recording in %d...",recordingCountDownNumber-1]];
    
    if (recordingCountDownNumber == 1)
    {
        [countdownLbl setText:@"Recording in progress!"];
        [micLevel setHidden:NO];
         [stopBtn setEnabled:YES];
        [self startRecording];
    }
    
    recordingCountDownNumber--;
}

-(IBAction) messageTypeSegmentedControlIndexChanged {
    [self setControlVisibility];
}

-(void)startRecording
{
    NSLog(@"startRecording");
    audioRecorder = nil;
    
    [self recordTimerStart];
    [self micLevelTimerStart];
     [timeRemaingLbl setHidden:NO];
    
    // Init audio with record capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSNumber *formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
    
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    
    
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: @"recordedFile.m4a"]];
    
    
    NSError *error = nil;
audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
    }else {
        long errorCode = CFSwapInt32HostToBig ((unsigned int)[error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode); 
        
    }
    NSLog(@"recording");
}

-(void) stopRecording
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    [micLevel setHidden:YES];
    [self micLevelTimerStop];
    NSLog(@"stopped");
    
    [countdownTimer invalidate];
    countDownTimerActive = NO;
    
    MessagingModel *mm = [MessagingModel sharedManager];   
    mm.recordFilePathForComposeMessageVoice = (NSString *)[NSTemporaryDirectory() stringByAppendingPathComponent: @"recordedFile.m4a"];
}

-(void) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
   
    NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: @"recordedFile.m4a"]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(void) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}


- (IBAction)saveMessage {
    
    SoundDirector *sd = [SoundDirector soundDirector];
    [sd stopSounds];
    
    [self showPleaseWait];
    
	AddMessageService *messagingService = [[AddMessageService alloc] init];
    UserModel *userModel = [UserModel userModel];
    
    messageComposing.messageText =     [NSString stringWithFormat:@"Message From %@ ... %@",userModel.userSettings.userFullName,messageComposing.messageText];
    
    if (messageTypeSegmentedControl.selectedSegmentIndex == 0)
    {
        MessagingModel *mm = [MessagingModel sharedManager];
    
        NSURL *url = [NSURL fileURLWithPath:(NSString *)mm.recordFilePathForComposeMessageVoice];
        NSData *microphoneData = [NSData dataWithContentsOfURL:url];
        messageComposing.sound = microphoneData;
    }
	[messagingService sendMessage:messageComposing AndReturnTo:self];

    
    
    // save the recipients to the recently used
    MessagingModel *messagingModel = [MessagingModel sharedManager];
	
	for (FacebookUser *fbUser in messagingModel.targetFriends)
	{
        [messagingModel addToRecentlyUsedRecipients:fbUser];
    }
    
    [messagingModel saveRecentlyUsedRecipients];
    
    NSMutableArray *nonBedBuzzUsers = [[NSMutableArray alloc] init];
    for (FacebookUser *fbUser in messagingModel.targetFriends)
	{
        if (!fbUser.isBedBuzzUser)
        {
            [nonBedBuzzUsers addObject:fbUser.uid];
        }
    }
    
    if (nonBedBuzzUsers.count > 0)
    {
        FacebookModel *fbModel = [FacebookModel sharedManager];
        [fbModel requestDialog:nonBedBuzzUsers];
    }
    
}

-(void) messageServiceResult:(NSString*)result
{
    [self hidePleaseWait];
    
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        
        // close the popover
        SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        [appDelegate.clockViewController.messagingPopoverController dismissPopoverAnimated:YES ];
        [appDelegate.clockViewController showMessageSent];
        
        // reset the page to the first one
        [[self navigationController] popViewControllerAnimated:YES];
        
    }
    else
    {
        [[[[iToast makeText:NSLocalizedString(@"Message sent!", @"")] 
           setGravity:iToastGravityBottom] setDuration:1000] show];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    UserModel *userModel = [UserModel userModel];
    if (!userModel.userSettings.isPaidUser)
    {
        // decrement the users send message credits by one
        userModel.userSettings.sendMessageCredits--;
        [userModel saveUserSettings];
    }
}

- (void) speechGenerated
{
    [self hidePleaseWait];
    
    // say the message
    SoundDirector *soundDirector = [SoundDirector soundDirector];
    [soundDirector sayTestMessage];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];  
    
}

@end
