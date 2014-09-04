//
//  WelcomeViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizardDelegate.h"
#import "Welcome1ViewController.h"
#import "Welcome2EnterNameViewController.h"
#import "Welcome3EnableFacebookViewController.h"
#import "RedirectingToFacebookViewController.h"

@interface WelcomeViewController : UIViewController <WizardDelegate>
{
    UIView *currentWizardView;
    Welcome1ViewController *welcome1;
    Welcome2EnterNameViewController *welcome2;
    Welcome3EnableFacebookViewController *welcome3;
    RedirectingToFacebookViewController *redirectScreen;
    
}

@property (nonatomic, strong) Welcome1ViewController *welcome1;
@property (nonatomic, strong) Welcome2EnterNameViewController *welcome2;
@property (nonatomic, strong) Welcome3EnableFacebookViewController *welcome3;
@property (nonatomic, strong) RedirectingToFacebookViewController *redirectScreen;

@end
