//
//  Welecome1ViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"
#import "WizardAnimationDelegate.h"

@interface Welcome1ViewController : UIViewController <WizardAnimationDelegate>
{
    id <WizardDelegate> wizardDelegate;
    
}
-(IBAction)nextBtnFromScreen1Clicked:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass;

@end
