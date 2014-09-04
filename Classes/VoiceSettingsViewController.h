//
//  VoiceSettingsViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 7/29/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechGeneratedDelegate.h"


@interface VoiceSettingsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, SpeechGeneratedDelegate> {
	UITableView *voiceSettingsTableView;
	NSIndexPath *lastIndexPath;
	IBOutlet UITextField* nameTxt;
	IBOutlet UITextField* messageTxt;
    IBOutlet UIButton* buySaveBtn;
	IBOutlet UIActivityIndicatorView* spinner;
	int soundsReceived;
	BOOL generatingSpeechForTest;
    NSString *currentVoiceName;
    NSString *currentUserName;
    NSString *currentAdditionalMessage;
}

@property (nonatomic, strong) IBOutlet UITableView *voiceSettingsTableView;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
-(void)enableDisableBuySaveButton;

- (IBAction)buySavePressed:(id)sender;
- (IBAction)testSounds;
- (IBAction)dismissKeyboard:(id)sender;
-(void)generateSpeech:(BOOL)forTest;
- (void)speechGenerated;
-(void)refreshSaveBuybutton;
-(void)saveBtnClicked;
-(void)buyBtnClicked;

@end
