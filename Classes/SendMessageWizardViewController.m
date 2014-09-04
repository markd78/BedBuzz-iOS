//
//  SendMessageWizardViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/9/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "SendMessageWizardViewController.h"
#import "WizardDelegate.h"
#import "WizardAnimationDelegate.h"
#import "ViewHelper.h"
#import "Flurry.h"

@implementation SendMessageWizardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass
{
    wizardDelegate = delegateClass;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Flurry logEvent:@"send message wizard"];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)finishAnimationComplete
{
     [self.view removeFromSuperview];
    
    // tell delegate we're done
    [wizardDelegate showNextScreen:mainClockScreen FromCurrentScreen:welcome3EnableFacebookScreen];
}

- (IBAction)yesClicked:(id)sender
{
    [Flurry logEvent:@"send message wizard - yes"];
    
    // dismiss the wizard
    ViewHelper *vh = [ViewHelper sharedManager];
    
    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:nil];
    
    // tell delegate (main screen) to show messaging
     [wizardDelegate showNextScreen:messagingScreen FromCurrentScreen:showMessagesWizard];
    
}
- (IBAction)noClicked:(id)sender
{
    [Flurry logEvent:@"send message wizard - no"];
    
    ViewHelper *vh = [ViewHelper sharedManager];

    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
}

@end
