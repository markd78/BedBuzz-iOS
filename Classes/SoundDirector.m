//
//  SoundDirector.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundDirector.h"

#import <AVFoundation/AVFoundation.h>
#import "NSMutableArray+QueueAdditions.h"
#import "WeatherModel.h"
#import "AlarmsModel.h"
#import "UserModel.h"
#import "MessagingModel.h"
#import "MessageVO.h"
#import "RSSModel.h"
#import "RecordingCountdownFinishedDelegate.h"
#import "RSSClip.h"

static SoundDirector *sharedSoundDirector = nil;

@implementation SoundDirector
@synthesize isAVAudioSessionInitalized;


#pragma mark Singleton Methods
+ (id)soundDirector {
	@synchronized(self) {
		if(sharedSoundDirector == nil)
			sharedSoundDirector = [[super allocWithZone:NULL] init];
	}
	return sharedSoundDirector;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self soundDirector];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	playQueue  = [[NSMutableArray alloc] init];
	
	isAlarmPlaying = NO;
	isMessagePlaying = NO;
    isCountdownPlaying = NO;
    isAVAudioSessionInitalized = NO;
    
	return self;
}

-(void)addMessageObjectToPlayQueue:(MessageVO *)objectToAdd {
	[playQueue enqueue:objectToAdd];
}

-(void)addRSSClipObjectToPlayQueue:(RSSClip *)objectToAdd {
	[playQueue enqueue:objectToAdd];
}

-(void)addToPlayQueue:(NSString *)objectToAdd {
	[playQueue enqueue:objectToAdd];
}

-(void)playSoundSequence {
	[self playFirstSoundInQueue];
}

-(void)initializeAudioPlayer {
	// just to initalize the audio player
	NSString *fileName = [[self getVoiceDir] stringByAppendingString:@"oh.mp3"];
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:fileName, [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	
	[audioPlayer prepareToPlay];
}

-(void)addAddtionalMessage:(BOOL)forTest {
	
	UserModel *userModel = [UserModel userModel];
    
	if ( (userModel.userSettings.additionalMessage != (id)[NSNull null] && userModel.userSettings.additionalMessage.length != 0 ) || forTest)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *filePath;
		
		if (!forTest)
		{
			filePath = [documentsDirectory stringByAppendingPathComponent:@"additionalMessage.mp3"];
		}
		else {
			filePath = [documentsDirectory stringByAppendingPathComponent:@"additionalMessageTest.mp3"];
		}
        
		[self addToPlayQueue:filePath];
        
	}
}

-(BOOL)addPersonalGreeting:(BOOL)forTest {
    
	UserModel *userModel = [UserModel userModel];
	if (userModel.userSettings.shouldGreetWithName || forTest)
	{
		// get document directory
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath ;
		
		// get time now
		NSDate *now = [NSDate date];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
		NSInteger hour = [components hour];
		
		if (!forTest)
		{
			if (hour <12)
			{
				filePath = [documentsDirectory stringByAppendingPathComponent:@"/goodMorning.mp3"];
			}
			else if (hour >=12 && hour < 18)
			{
				filePath = [documentsDirectory stringByAppendingPathComponent:@"/goodAfternoon.mp3"];
			}
			else {
				filePath = [documentsDirectory stringByAppendingPathComponent:@"/goodEvening.mp3"];
			}
		}
		else {
			if (hour <12)
			{
				filePath = [documentsDirectory stringByAppendingPathComponent:@"/goodMorningTest.mp3"];
			}
			else if (hour >=12 && hour < 18)
			{
				filePath = [documentsDirectory stringByAppendingPathComponent:@"/goodAfternoonTest.mp3"];
			}
			else {
				filePath = [documentsDirectory stringByAppendingPathComponent:@"/goodEveningTest.mp3"];
			}
		}
        
        
		[self addToPlayQueue:filePath];
	}
	else
	{
		// get time now
		NSDate *now = [NSDate date];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
		NSInteger hour = [components hour];
		NSString *filePath;
		
		if (hour <12)
		{
			filePath =  [[self getVoiceDir] stringByAppendingString:@"/goodMorning.mp3"]; 
		}
		else if (hour >=12 && hour < 18)
		{
			filePath =  [[self getVoiceDir] stringByAppendingString:@"/goodAfternoon.mp3"]; 
		}
		else {
			filePath =  [[self getVoiceDir] stringByAppendingString:@"/goodEvening.mp3"]; 
		}
		
		[self addToPlayQueue:filePath];
	}
	
	return YES;
	
}

-(NSString *)getMonthFile {
	
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitMonth) fromDate:date];
	NSInteger month = [components month];
	NSString *fileName;
	
	switch (month) {
		case 1:
			fileName = @"/months/january.mp3";
			break;
		case 2:
			fileName = @"/months/february.mp3";
			break;
		case 3:
			fileName = @"/months/march.mp3";
			break;
		case 4:
			fileName = @"/months/april.mp3";
			break;
		case 5:
			fileName = @"/months/may.mp3";
			break;
		case 6:
			fileName = @"/months/june.mp3";
			break;
		case 7:
			fileName = @"/months/july.mp3";
			break;
		case 8:
			fileName = @"/months/august.mp3";
			break;
		case 9:
			fileName = @"/months/september.mp3";
			break;
		case 10:
			fileName = @"/months/october.mp3";
			break;
		case 11:
			fileName = @"/months/november.mp3";
			break;
		case 12:
			fileName = @"/months/december.mp3";
			break;
		default:
            fileName = @"";
			break;
	}
	
	return fileName;
    
}

-(NSString *)getDateFile {
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitDay) fromDate:date];
	NSInteger day = [components day];
	NSString *file;
	if (day!=1 && day!=2 && day!=3 && day!=21 && day!=22 && day!=23 && day!=31)
	{
		file = [NSString stringWithFormat:@"monthDates/%ldth.mp3", (long)day];
	}
	else if (day == 1 || day == 21 || day ==31)
	{
		file = [NSString stringWithFormat:@"monthDates/%ldst.mp3", (long)day];	
	}
	else if (day == 2 || day == 22)
	{
		file = [NSString stringWithFormat:@"monthDates/%ldnd.mp3", (long)day];	
	}
	else if (day == 3 || day == 23)
	{
		file = [NSString stringWithFormat:@"monthDates/%ldrd.mp3", (long)day];	
	}
	
	return file;
}

-(NSString *)getVoiceDir
{
	UserModel *userModel = [UserModel userModel];
	
	NSString *dir;
	
	if ([userModel.userSettings.voiceName isEqualToString:@"usenglishmale1"]) {
		
		dir = @"%@/media/english/paul";
	}
	else if ( [userModel.userSettings.voiceName isEqualToString:@"usenglishfemale1"] )
	{
		dir = @"%@/media/english.usfemale";
	}
	else
	{
		dir = @"%@/media/english.ukfemale";
	}
	
	return dir;
}

-(void)addTimeFilesToQueue {
	
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/todaysDate.mp3"]];
	
	//[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/media/english.ukfemale/todaysDate.mp3"]];
	
	//[self addToPlayQueue:[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"media/english.ukfemale/todaysDate.mp3"]];
	
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(kCFCalendarUnitWeekday | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:date];
	NSInteger hour = [components hour];
	
	switch (components.weekday) {
		case 1:
			// sunday
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/sunday.mp3"]];
            
			break;
		case 2:
			// mon
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/monday.mp3"]];
            
			break;
		case 3:
			// tue
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/tuesday.mp3"]];
            
			break;
		case 4:
			// wed
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/wednesday.mp3"]];
            
			break;
		case 5:
			// thu
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/thursday.mp3"]];
            
			break;
		case 6:
			// fri
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/friday.mp3"]];
            
			break;
		case 7:
			// sat
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/days/saturday.mp3"]];
            
			break;
		default:
			break;
	}
	
	NSString *file = [self getMonthFile];
	[self addToPlayQueue:[NSString stringWithFormat:@"%@/%@", [self getVoiceDir], file]];
	
	file = [self getDateFile];
	[self addToPlayQueue:[NSString stringWithFormat:@"%@/%@", [self getVoiceDir], file]];
	
	NSString *amPMFile;
	
	if (hour >=12)
	{
		amPMFile = [[self getVoiceDir] stringByAppendingString:@"/pm.mp3"]; 
	}
	else
	{
		amPMFile =  [[self getVoiceDir] stringByAppendingString:@"/am.mp3"];	
	}
	
	
	if (hour == 0)
	{
		hour = 12;
	}
	else if (hour >12)
	{
		// convert hour to 12 hr (from 24)
		hour = hour -12;
	}
	
	NSString *hourFile = [NSString stringWithFormat:@"numbers/%ld.mp3", (long)hour];
	
	hourFile = [NSString stringWithFormat:@"%@/%@", [self getVoiceDir], hourFile] ; 
	
	
	NSInteger minute = [components minute];
	
	NSString *minuteFile = [NSString stringWithFormat:@"numbers/%ld", (long)minute] ;
    
	minuteFile = [minuteFile stringByAppendingString:@".mp3"];
	
	minuteFile = [NSString stringWithFormat:@"%@/%@", [self getVoiceDir],minuteFile ];
	
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/theTimeIs.mp3"]];
	
	[self addToPlayQueue:hourFile];
	
	if (minute != 0)
	{
		if (minute < 10)
		{
			[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/oh.mp3"]];
		}
		
		[self addToPlayQueue:minuteFile];
	}
	
	
	[self addToPlayQueue:amPMFile];
	
	//int day = [components weekday];
}

-(void)playTime {
	
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
    [audioPlayer stop];
	
	[self addPersonalGreeting:NO];
	
	[self addAddtionalMessage:NO];
	
	[self addTimeFilesToQueue];
	
	[self playSoundSequence];
}

-(void)playTimeForTest:(BOOL)withAdditionalMessage {
	
	
	
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addPersonalGreeting:YES];
	
    if (withAdditionalMessage)
    {
        [self addAddtionalMessage:YES];
	}
    
	[self playSoundSequence];
}

-(void)playFirstSoundInQueue {
	
	if ([playQueue count] != 0)
	{
		if ([[playQueue objectAtIndex:0]  isKindOfClass:[NSString class]])
		{
			// play first sound in queue
			NSString *sound = [playQueue objectAtIndex:0];
            
			// play it
			[self playSound:sound];
		}
		else if ([[playQueue objectAtIndex:0] isKindOfClass:[MessageVO class]]) {
			// it is of type MESSAGE
			[self playSoundFromData:[playQueue objectAtIndex:0]];
            
            [messagingPlayingDelegate messageIsBeingPlayed:[playQueue objectAtIndex:0]];
            
            isMessagePlaying = YES;
		}
		else {
			// it is of type RSSCLIP
			[self playSoundFromRSSClipData:[playQueue objectAtIndex:0]];
		}
        
	}
    
}

-(void)playNextSound
{
    if (playQueue==nil || ([playQueue count] == 1 && !isAlarmPlaying))
    {
        if (isCountdownPlaying)
        {
            isCountdownPlaying = NO;
        }
        
        return;
    }
    
    // then pop it off
	//if ([playQueue count] != 1)
    if ([playQueue count] > 1)
	{
		[playQueue dequeue];
        
		[self playFirstSoundInQueue];
	}
	else {
		// start mp3 music
		if (isAlarmPlaying)
		{
			appMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
			[appMusicPlayer setQueueWithItemCollection:currentAlarm.alarmMusic];
			[appMusicPlayer play];
		}
        
        [audioPlayer stop];
     //   [audioPlayer release];
	}
}

-(void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL) flag {
	
	if (isRSSClipPlaying)
	{
		isRSSClipPlaying = NO;
		[rssWebViewDelegate RSSClipEnded];
	}
	
	// if we played a message, then mark it as read
	if (currentMessagePlaying)
	{
		currentMessagePlaying.isRead = YES;
		MessagingModel *model = [MessagingModel sharedManager];
		[model saveMessageAsRead:currentMessagePlaying];
		currentMessagePlaying = nil;
	}
	
    if (isMessagePlaying)
    {
        [messagingPlayingDelegate messageFinishedPlaying];
        isMessagePlaying = NO;
    }
    
    if (isCountdownPlaying && recordingCountdownFinishedDelegate!=nil)
    {
        [recordingCountdownFinishedDelegate recordingCountdownFinished];
    }
    
	[self playNextSound];
	
	
    
    
}

-(BOOL)isEvening {
	NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
	NSInteger hour = [components hour];
	
	if (hour <18)
	{
		return NO;
	}
	
	return YES;
}

-(void)sayWelcomeWizard {
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
    
    [self addToPlayQueue:@"%@/media/english.ukfemale/welcomeWizard1.mp3"];
    
	[self playSoundSequence];
}

-(void)sayEnableFacebook {
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
    [self addPersonalGreeting:NO];
    
    [self addToPlayQueue:@"%@/media/english.ukfemale/enableFacebook.mp3"];
    
	[self playSoundSequence];
}

-(void)sayWelcome {
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addPersonalGreeting:NO];
	
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/welcome-ipad.mp3"]];
    }
    else
    {
        [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/welcome1.mp3"]];
	}
    
	[self playSoundSequence];
}

-(void)sayTestMessage {
    // reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/messageTest.mp3"];
    
    [self addToPlayQueue:filePath];
    [self playSoundSequence];
}

-(void)sayThanksForReview {
	
    [self stopSounds];
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:@"%@/media/english.ukfemale/reviewApp.mp3"];
	
	[self playSoundSequence];
}

-(void)playPleaseReview {
    
    [self stopSounds];
    
    // reset the play queue
    playQueue  = [[NSMutableArray alloc] init];
    
    [self addToPlayQueue:@"%@/media/english.ukfemale/leaveReview.mp3"];
    
    [self playSoundSequence];
}

-(void)saySubscribeQuestion {
    
    [self stopSounds];
    
    // reset the play queue
    playQueue  = [[NSMutableArray alloc] init];
    
    [self addToPlayQueue:@"%@/media/english.ukfemale/subscribeQuestion.mp3"];
    
    [self playSoundSequence];
}

-(void)sayChangeVoiceQuestion {
	
    [self stopSounds];
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:@"%@/media/english.ukfemale/voiceQuestion.mp3"];
	
	[self playSoundSequence];
}

-(void)saySendMessageQuestion {
	
    [self stopSounds];
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/sendMessageQuestion.mp3"]];
	
	[self playSoundSequence];
}

-(void)saySelectFriendsHelp {
	
    [self stopSounds];
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/firstSelectFriends.mp3"]];
	
	[self playSoundSequence];
}

-(void)sayTypeMessageHelp {
	
    [self stopSounds];
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/typeMessage.mp3"]];
	
	[self playSoundSequence];
}

-(void)sayHello {
	
    [self stopSounds];
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/initialGreeting.mp3"]];
	
	[self playSoundSequence];
}

-(void)sayUpdateMessage {
	
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
	[self addToPlayQueue:@"%@/media/english.ukfemale/updateToVersion2.mp3"];
	
	[self playSoundSequence];
}


-(void)addWeatherFilesToQueue:(BOOL)useSimpleForecast {
	WeatherModel *weatherModel = [WeatherModel weatherModel];
	UserModel *userModel = [UserModel userModel];
	
	// currently the weather is
	[self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/currentlyTheWeatherIs.mp3"]];
	
	// weather
	NSString *currentWeatherSound = [weatherModel.weatherNow.condition.soundFileName stringByAppendingString:@".mp3"];
    if (currentWeatherSound!=nil)
    {
        NSString *weatherFileName = [@"/weatherSounds/" stringByAppendingString:currentWeatherSound];
        currentWeatherSound = [NSString stringWithFormat:@"%@/%@", [self getVoiceDir], weatherFileName] ;	
        
        if ([weatherModel isDark] && [currentWeatherSound rangeOfString:@"sunny.mp3"].location  != NSNotFound)
        {
            currentWeatherSound =  [NSString stringWithFormat:@"%@/%@", [self getVoiceDir], @"weatherSounds/clear.mp3"]  ;
        }
        [self addToPlayQueue:currentWeatherSound];
        
        
        // the temperature is
        [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/theTempIs.mp3"]];
        
        // minus if < 0
        if (weatherModel.weatherNow.currentTempF < 0)
        {
            [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/numbers/minus.mp3"]];
        }
        
        
        
        // temp
        if (userModel.userSettings.isCelcius)
        {
            NSString *tempFile = [[NSString stringWithFormat:@"%d", weatherModel.weatherNow.currentTempC] stringByAppendingString:@".mp3"];
            tempFile = [NSString stringWithFormat:@"%@//numbers/%@", [self getVoiceDir], tempFile];	
            [self addToPlayQueue:tempFile];
            
            // degrees F
            [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/degreesCelcius.mp3"]];
        }
        else {
            NSString *tempFile = [[NSString stringWithFormat:@"%d", weatherModel.weatherNow.currentTempF] stringByAppendingString:@".mp3"];
            tempFile = [NSString stringWithFormat:@"%@/numbers/%@", [self getVoiceDir], tempFile];	
            [self addToPlayQueue:tempFile];
            
            // degrees F
            [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/degreesF.mp3"]];
        }
        
        if (useSimpleForecast)
        {
            // if not evening, weather forecast for today
            if ([self isEvening] == NO)
            {
                [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/forecastToday.mp3"]];
                NSString *todayWeatherSound = [weatherModel.weatherToday.condition.soundFileName stringByAppendingString:@".mp3"];
                todayWeatherSound = [NSString stringWithFormat:@"%@/weatherSounds/%@", [self getVoiceDir], todayWeatherSound];	
                [self addToPlayQueue:todayWeatherSound];
                
                
                [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/withHighsOf.mp3"]];
                
                if (userModel.userSettings.isCelcius)
                {
                    NSString *tempFile = [[NSString stringWithFormat:@"%d", weatherModel.weatherToday.maxTempC] stringByAppendingString:@".mp3"];
                    tempFile = [NSString stringWithFormat:@"%@/numbers/%@", [self getVoiceDir], tempFile];	
                    [self addToPlayQueue:tempFile];
                    
                    // degrees C
                    [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/degreesCelcius.mp3"]];
                }
                else {
                    NSString *tempFile = [[NSString stringWithFormat:@"%d", weatherModel.weatherToday.maxTempF] stringByAppendingString:@".mp3"];
                    tempFile = [NSString stringWithFormat:@"%@/numbers/%@", [self getVoiceDir], tempFile];	
                    [self addToPlayQueue:tempFile];
                    
                    // degrees F
                    [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/degreesF.mp3"]];
                }
                
                
                
            }
            else {
                // else, weather forecast for tomorrow
                [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/forecastTomorrow.mp3"]];
                
                NSString *tomorrowWeatherSound = [weatherModel.weatherTomorrow.condition.soundFileName stringByAppendingString:@".mp3"];
                tomorrowWeatherSound = [NSString stringWithFormat:@"%@/weatherSounds/%@", [self getVoiceDir], tomorrowWeatherSound];	
                [self addToPlayQueue:tomorrowWeatherSound];
                
                [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/withHighsOf.mp3"]];
                
                if (userModel.userSettings.isCelcius)
                {
                    NSString *tempFile = [[NSString stringWithFormat:@"%d", weatherModel.weatherTomorrow.maxTempC] stringByAppendingString:@".mp3"];
                    tempFile = [NSString stringWithFormat:@"%@/numbers/%@", [self getVoiceDir], tempFile];	
                    [self addToPlayQueue:tempFile];
                    
                    // degrees C
                    [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/degreesCelcius.mp3"]];
                }
                else
                {
                    NSString *tempFile = [[NSString stringWithFormat:@"%d", weatherModel.weatherTomorrow.maxTempF] stringByAppendingString:@".mp3"];
                    tempFile = [NSString stringWithFormat:@"%@/numbers/%@", [self getVoiceDir], tempFile];	
                    [self addToPlayQueue:tempFile];
                    
                    // degrees F
                    [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/degreesF.mp3"]];
                }
                
                
            }
        }
        else
        {
            // use detail txt forecase
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/weatherTxt.mp3"];
            [self addToPlayQueue:filePath];
        }

    }
    	
}

-(void)addRSSClipsToPlayQueue {
    
	RSSModel *rssModel = [RSSModel sharedManager];
	
	for (RSSClip *rssClip in rssModel.rssClips)
	{
		[self addRSSClipObjectToPlayQueue:rssClip];
	}
}

-(void)addRSSClipsToPlayQueueAndLetMeKnowWhenTheyAreBeingPlayed:(id <RSSClipBeingPlayedDelegate>)delegateClass {
	rssWebViewDelegate = delegateClass;
	
	[self addRSSClipsToPlayQueue];
}

-(void)addRSSClipsToPlayQueueAndPlay {
    
    // reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
    [audioPlayer stop];
    
	[self addRSSClipsToPlayQueue];
	[self playSoundSequence];
}



-(void)playWeather:(BOOL)useSimpleForcast {
    
	// reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
	
    [audioPlayer stop];
    
	[self addWeatherFilesToQueue:useSimpleForcast];
	
	[self playSoundSequence];
    
}

-(void)addMessagesToPlayQueue {
    
	MessagingModel *messagingModel = [MessagingModel sharedManager];
	
	for (MessageVO *message in messagingModel.messagesToPlay)
	{
		[self addMessageObjectToPlayQueue:message];
	}
	
}

-(void)addMessagesToPlayQueueAndLetMeKnowWhenTheyAreBeingPlayed:(id <MessagePlayingDelegate>)delegateClass
{
    messagingPlayingDelegate = delegateClass;
    [self addMessagesToPlayQueue];
    
}

-(void)addAdToPlayQueue {
    
    // user has 3 in 10 chance to get an ad
    int r = arc4random() % 10;
    
    if (r < 6)
    {
        [self addToPlayQueue:@"%@/media/english.ukfemale/subscribeQuestion.mp3"];
        
    }
    
    /* if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
     if (r == 1)
     {
     [self addToPlayQueue:@"%@/media/english.ukfemale/ads/ad1-ipad.mp3"];
     }
     else if (r == 2)
     {
     [self addToPlayQueue:@"%@/media/english.ukfemale/ads/ad2-ipad.mp3"];
     }
     else if (r == 3)
     {
     [self addToPlayQueue:@"%@/media/english.ukfemale/ads/ad3-ipad.mp3"];
     }
     
     
     }
     else
     {
     if (r == 1)
     {
     [self addToPlayQueue:@"%@/media/english.ukfemale/ads/ad1.mp3"];
     }
     else if (r == 2)
     {
     [self addToPlayQueue:@"%@/media/english.ukfemale/ads/ad2.mp3"];
     }
     else if (r == 3)
     {
     [self addToPlayQueue:@"%@/media/english.ukfemale/ads/ad3.mp3"];
     }
     }*/
}

-(void)addMessagesAndAdsToPlayQueueAndPlay {
    // reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
    
    [self addMessagesToPlayQueue ];
    
    UserModel *userModel = [UserModel userModel];
    
    if (!userModel.userSettings.isPaidUser)
    {
        [self addAdToPlayQueue ];
    }
    
    [self playSoundSequence];
}

-(void)addMessagesToPlayQueueAndPlay {
    
    // reset the play queue
	playQueue  = [[NSMutableArray alloc] init];
    
	[self addMessagesToPlayQueue ];
	
    [self playSoundSequence];
}


-(void)playSoundFromData: (MessageVO *)messageToPlay {
	
	NSError *error;
	currentMessagePlaying = messageToPlay;
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	audioPlayer = [[AVAudioPlayer alloc] initWithData:messageToPlay.sound error:&error];
	
	audioPlayer.numberOfLoops = 0;
	[audioPlayer setVolume:1];
	[audioPlayer setDelegate:self];
	if (audioPlayer == nil)
    {
		NSLog(@"Error: %@", [error description]);
        [self playNextSound];
    }
    
	//	else
	//		[audioPlayer play];
	
    [audioPlayer prepareToPlay];
    [audioPlayer play];
	
	isRSSClipPlaying = NO;
	
}

-(void)playSoundFromRSSClipData: (RSSClip *)rssClipToPlay {
	
	NSError *error;
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	audioPlayer = [[AVAudioPlayer alloc] initWithData:rssClipToPlay.sound error:&error];
	
	audioPlayer.numberOfLoops = 0;
	[audioPlayer setVolume:1];
	[audioPlayer setDelegate:self];
	if (audioPlayer == nil)
    {
		NSLog(@"Error: %@", [error description]);
        [self playNextSound];
    }
    
	//	else
	//		[audioPlayer play];
	
    [audioPlayer prepareToPlay];
    [audioPlayer play];
	
	// let the rss delegate know that a RSS Clip is being played
	[rssWebViewDelegate RSSClipBeingPlayed:rssClipToPlay.link];
	
	isRSSClipPlaying = YES;
	
}

-(void)playSound: (NSString *)filenameToPlay {
	
	NSString *fileName = filenameToPlay;
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:fileName, [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	
	[[AVAudioSession sharedInstance] setDelegate: self];
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
	[[AVAudioSession sharedInstance] setActive: YES error: nil];
	
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
	[audioPlayer setVolume:1];
	[audioPlayer setDelegate:self];
	if (audioPlayer == nil)
    {
		NSLog(@"Error: %@", [error description]);
        [self playNextSound];
    }
    //	else
    //		[audioPlayer play];
	
    [audioPlayer prepareToPlay];
    [audioPlayer play];
	
	isRSSClipPlaying = NO;
}

-(void)stopPlayingRSS {
    
    NSMutableArray *clipsToRemove = [[NSMutableArray alloc] init];
    
    for (id audioObj in playQueue)
    {
        if ([audioObj isKindOfClass:[RSSClip class]] )
        {
            [clipsToRemove addObject:audioObj];
            
        }
    }
    
    for (RSSClip *clip in clipsToRemove)
    {
        [playQueue removeObject:clip];
    }
    
    [audioPlayer stop];
    
    [self playFirstSoundInQueue];
    
    
    // start mp3 music
    if (isAlarmPlaying)
    {
        appMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        [appMusicPlayer setQueueWithItemCollection:currentAlarm.alarmMusic];
        [appMusicPlayer play];
    }
    
}

-(void)playAlarm: (Alarm *)alarmToPlay {
    
	if (!isAlarmPlaying)
    {
        [self stopSounds];
        
        playQueue  = [[NSMutableArray alloc] init];
        
        isAlarmPlaying = YES;
        currentAlarm = alarmToPlay;
        
        [self addPersonalGreeting:NO];
        
        [self addAddtionalMessage:NO];
        
        // now play the time & weather
        [self addTimeFilesToQueue];
        
        UserModel *userModel = [UserModel userModel];
        WeatherModel *weatherModel = [WeatherModel weatherModel];
        
        if (!userModel.userSettings.isOfflineMode && weatherModel.weatherNow != nil)
        {
            [self addWeatherFilesToQueue:YES];
        }
        
        [self playSoundSequence];
	}
}

-(void)stopAlarm {
	
	isAlarmPlaying = NO;
	
	[appMusicPlayer stop];
	[self stopSounds];
}

-(void)snoozeClicked {
	[self stopAlarm];
}

-(void)stopSounds {
    playQueue  = [[NSMutableArray alloc] init];
    [audioPlayer stop];
}

-(void)playRecordedMessage
{
    playQueue  = [[NSMutableArray alloc] init];
    MessagingModel *mm = [MessagingModel sharedManager];
    NSString *filePath = (NSString *)mm.recordFilePathForComposeMessageVoice;
    [self addToPlayQueue:filePath];
    [self playFirstSoundInQueue];
}

-(void)playRecordedCountdownAndReturnTo:(id <RecordingCountdownFinishedDelegate>)delegateClass
{
    isCountdownPlaying = YES;
    recordingCountdownFinishedDelegate = delegateClass;
    
    [self stopSounds];
    [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/numbers/3.mp3"]];
    [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/numbers/2.mp3"]];
     [self addToPlayQueue:[[self getVoiceDir] stringByAppendingString:@"/numbers/1.mp3"]];
    
     [self playFirstSoundInQueue];
}

@end
