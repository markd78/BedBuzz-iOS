//
//  AlarmGoingOffViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherUpdatedDelegate.h"
#import "AlarmListenDelegate.h"
#import "FetchMessagesDelegate.h"
#import "FetchRSSDelegate.h"
#import "RSSClipBeingPlayedDelegate.h"
#import "FetchMessagesService.h"
#import "FetchRSSClipsService.h"
#import "MessageViewViewController.h"
#import "MessagePlayingDelegate.h"

@interface AlarmGoingOffViewController : UIViewController <AlarmListenDelegate, 
			WeatherUpdatedDelegate, FetchMessagesDelegate, FetchRSSDelegate, RSSClipBeingPlayedDelegate, MessagePlayingDelegate> {
	IBOutlet UISlider* sleepySlider;
	IBOutlet UIButton* snoozeButton;
	IBOutlet UIImageView* weatherImageView;
	IBOutlet UILabel* weatherTempLbl;
	IBOutlet UILabel* weatherTempUnitLbl;
	IBOutlet UIWebView* rssWebView;
	IBOutlet UIButton* rssWebViewCloseBtn;
	IBOutlet UIImageView* arrowImageView;
                
	IBOutlet UILabel* clockLabel;
	NSTimer *myTicker;
    NSTimer *animateArrowTimer;
                UIWebView *webView;
                
    FetchMessagesService *mService;
    FetchRSSClipsService *rssService;    
                CGRect originalArrowFrame;
                
                MessageViewViewController *messageViewController;
	
}

- (IBAction)snoozeClicked:(id)sender;
- (IBAction)closeRSSButtonClicked:(id)sender;
- (IBAction)sleepySliderValueChanged:(id)sender;

- (void)runTimer;

-(void)weatherWasUpdated;

-(void)showRefreshingWeatherSpinner;

-(void)hideRefreshingWeatherSpinner;
-(void) messagesHaveBeenFetched;
-(void) rssClipsHaveBeenFetched;
-(void)RSSClipBeingPlayed:(NSString *) url;
@end
