//
//  SoundDirector.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import "NSMutableArray+QueueAdditions.h"
#import "Alarm.h"
#import "MessageVO.h"
#import "RSSClip.h"
#import "RSSClipBeingPlayedDelegate.h"
#import "MessagePlayingDelegate.h"
#import "RecordingCountdownFinishedDelegate.h"

@interface SoundDirector : NSObject <AVAudioPlayerDelegate> {
	AVAudioPlayer *audioPlayer;
	MPMusicPlayerController* appMusicPlayer;
	NSMutableArray *playQueue;
	BOOL isAlarmPlaying;
	BOOL isRSSClipPlaying;
    BOOL isMessagePlaying;
    BOOL isCountdownPlaying;
    BOOL isAVAudioSessionInitalized;
    
	MessageVO *currentMessagePlaying;
	Alarm *currentAlarm;
	
	id <RSSClipBeingPlayedDelegate> rssWebViewDelegate;
    id <MessagePlayingDelegate> messagingPlayingDelegate;
    id <RecordingCountdownFinishedDelegate> recordingCountdownFinishedDelegate;
}
+ (id)soundDirector;
-(void)playSound:(NSString *)filename;
-(void)playSoundSequence;
-(void)playFirstSoundInQueue;
-(void)addToPlayQueue:(NSString *)objectToAdd;
-(void)playTime;
-(void)playTimeForTest:(BOOL)withAdditionalMessage;
-(void)playWeather:(BOOL)useSimpleForecast;
-(void)initializeAudioPlayer;
-(void)playAlarm:(Alarm *)alarmToPlay;
-(void)snoozeClicked;
-(void)stopAlarm;
-(void)sayWelcome;
-(void)sayHello;
-(void)sayUpdateMessage;
-(BOOL)addPersonalGreeting:(BOOL)forTest;
-(void)addRSSClipsToPlayQueueAndLetMeKnowWhenTheyAreBeingPlayed:(id <RSSClipBeingPlayedDelegate>)delegateClass;
-(void)addRSSClipsToPlayQueueAndPlay;
-(void)addMessagesToPlayQueue;
-(void)addMessagesToPlayQueueAndLetMeKnowWhenTheyAreBeingPlayed:(id <MessagePlayingDelegate>)delegateClass;
-(void)addRSSClipObjectToPlayQueue:(RSSClip *)objectToAdd;
-(void)playSoundFromData: (MessageVO *)messageToPlay;
-(void)playSoundFromRSSClipData: (RSSClip *)rssClipToPlay;
-(NSString *)getVoiceDir;
-(void)sayTestMessage;
-(void)stopPlayingRSS;
-(void)addMessagesToPlayQueueAndPlay;
-(void)addAdToPlayQueue;
-(void)addMessagesAndAdsToPlayQueueAndPlay;
-(void)stopSounds;
-(void)sayWelcomeWizard;
-(void)sayEnableFacebook;
-(void)saySendMessageQuestion;
-(void)sayTypeMessageHelp;
-(void)saySelectFriendsHelp;
-(void)sayThanksForReview;
-(void)saySubscribeQuestion;
-(void)sayChangeVoiceQuestion;
-(void)playPleaseReview;
-(void)playRecordedMessage;
-(void)playRecordedCountdownAndReturnTo:(id <RecordingCountdownFinishedDelegate>)delegateClass;
-(BOOL)isEvening;
@property (nonatomic) BOOL isAVAudioSessionInitalized;
@end
