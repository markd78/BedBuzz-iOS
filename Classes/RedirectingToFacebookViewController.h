//
//  RedirectingToFacebookViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/12/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardAnimationDelegate.h"
#import "WizardDelegate.h"
#import "FacebookLoggedInDelegate.h"

@interface RedirectingToFacebookViewController : UIViewController  <WizardAnimationDelegate,FacebookLoggedInDelegate>
{
    id <WizardDelegate> wizardDelegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass;

@end
