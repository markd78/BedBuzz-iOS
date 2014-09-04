//
//  ChangeVoiceQuestionViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 5/21/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"
#import "WizardAnimationDelegate.h"

@interface ChangeVoiceQuestionViewController : UIViewController <WizardAnimationDelegate>
{
}

@property (weak, nonatomic)  id <WizardDelegate> wizardDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass;
- (IBAction)yesClicked:(id)sender;
- (IBAction)noClicked:(id)sender;

@end
