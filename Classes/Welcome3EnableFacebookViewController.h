//
//  Welcome3EnableFacebook.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/9/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"
#import "FacebookLoggedInDelegate.h"
#import "WizardAnimationDelegate.h"

@interface Welcome3EnableFacebookViewController : UIViewController < WizardAnimationDelegate>
{
       id <WizardDelegate> wizardDelegate;
    Boolean enableFacebook;
}
- (IBAction)yesClicked:(id)sender;
- (IBAction)noClicked:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass;
@end
