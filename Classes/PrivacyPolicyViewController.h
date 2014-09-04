//
//  PrivacyPolicyViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 12/3/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyPolicyViewController : UIViewController
{
    IBOutlet UIWebView* webView;
    IBOutlet UIButton* backButton;
}

- (IBAction)backButtonPressed;

@end
