//
//  PleaseReviewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/9/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"
#import "WizardAnimationDelegate.h"

@interface PleaseReviewController : UIViewController <WizardAnimationDelegate>
{
id <WizardDelegate> wizardDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass;
- (IBAction)yesClicked:(id)sender;
- (IBAction)noClicked:(id)sender;
@end
