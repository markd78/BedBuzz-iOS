//
//  Welcome2EnterNameViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"
#import "SpeechGeneratedDelegate.h"
#import "WizardAnimationDelegate.h"

@interface Welcome2EnterNameViewController : UIViewController <WizardAnimationDelegate, SpeechGeneratedDelegate, UITextFieldDelegate>
{
IBOutlet UITextField* nameTxt;
IBOutlet UIButton* submitBtn;
IBOutlet UIActivityIndicatorView* spinner;
NSString *preName;
int numberOfSpeechGenerated;
    id <WizardDelegate> wizardDelegate;
    NSString *morningString;
	NSString *afternoonString;
	NSString *eveningString;
}

- (IBAction)submitClicked:(id)sender;
- (void)speechGenerated;
- (IBAction)dismissKeyboard:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass;
@property (nonatomic, strong) NSString *morningString;
@property (nonatomic, strong) NSString *afternoonString;
@property (nonatomic, strong) NSString *eveningString;
@end