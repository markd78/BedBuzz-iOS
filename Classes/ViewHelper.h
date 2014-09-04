//
//  ViewHelper.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WizardAnimationDelegate.h"



typedef enum{
    welcome1Screen =0,
    welcome2EnterNameScreen,
    welcome3EnableFacebookScreen,
    mainClockScreen,
    messagingScreen,
    showMessagesWizard,
    redirectingToFacebook,
    changeVoiceScreen,
    subscribeScreen,
    none
} WizardScreen;

@interface ViewHelper : NSObject
{
   UIView *currentView;
     id <WizardAnimationDelegate> wizardDelegate;
    bool currentViewIsInCenter;
}
+ (id)sharedManager;

-(UIView *)moveToStartPosition:(UIView *)v ForOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
-(UIView *)moveToEndPosition:(UIView *)v ForOrientation:(UIInterfaceOrientation)toInterfaceOrientation AndReturnTo:(id <WizardAnimationDelegate>)delegateClass;

-(UIView *)formatTheViewForWizard:(UIView *)v;
-(UIView *)formatTheViewForDarkWizard:(UIView *)v;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic)  bool currentViewIsInCenter;
@end

