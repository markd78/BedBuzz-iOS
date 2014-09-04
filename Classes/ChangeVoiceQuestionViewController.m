//
//  ChangeVoiceQuestionViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 5/21/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "ChangeVoiceQuestionViewController.h"
#import "ViewHelper.h"
#import "Flurry.h"
#import "SoundDirector.h"

@implementation ChangeVoiceQuestionViewController
@synthesize wizardDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    wizardDelegate = delegateClass;

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
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

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

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
    [wizardDelegate showNextScreen:mainClockScreen FromCurrentScreen:changeVoiceScreen];
}

- (IBAction)yesClicked:(id)sender
{
[Flurry logEvent:@"change voice question - yes"];

// dismiss the wizard
ViewHelper *vh = [ViewHelper sharedManager];

[vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];

    // tell delegate (main screen) to show messaging
    [wizardDelegate showNextScreen:changeVoiceScreen FromCurrentScreen:showMessagesWizard];
    
}
- (IBAction)noClicked:(id)sender
{
    [Flurry logEvent:@"change voice question - no"];

    SoundDirector *sd = [SoundDirector soundDirector];
    [sd stopSounds];
    
    ViewHelper *vh = [ViewHelper sharedManager];

    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
}


@end
