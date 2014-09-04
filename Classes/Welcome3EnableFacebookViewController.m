//
//  Welcome3EnableFacebook.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/9/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "Welcome3EnableFacebookViewController.h"
#import "WizardDelegate.h"
#import "FacebookModel.h"
#import "ViewHelper.h"
#import "SoundDirector.h"
#import "Flurry.h"

@implementation Welcome3EnableFacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndReturnTo:(id <WizardDelegate>)delegateClass
{
    wizardDelegate = delegateClass;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SoundDirector *sd = [SoundDirector soundDirector];
    [sd sayEnableFacebook];
    
    [Flurry logEvent:@"wizard3"];
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

- (IBAction)yesClicked:(id)sender
{
    [Flurry logEvent:@"enable facebook (wizard3) - yes"];
    
    enableFacebook = YES;
    
    SoundDirector *sd = [SoundDirector soundDirector];
    [sd stopSounds];
    
    // dismiss the wizard
    ViewHelper *vh = [ViewHelper sharedManager];
    
    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
}
- (IBAction)noClicked:(id)sender
{
    [Flurry logEvent:@"enable facebook (wizard3) - no"];
    
    enableFacebook = NO;
    
    SoundDirector *sd = [SoundDirector soundDirector];
    [sd stopSounds];
    
    // dismiss the wizard
    ViewHelper *vh = [ViewHelper sharedManager];
    
    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
}

-(void)finishAnimationComplete
{
     [self.view removeFromSuperview];
    
    if (enableFacebook)
    {
    // tell delegate we're done
    [wizardDelegate showNextScreen:redirectingToFacebook FromCurrentScreen:welcome3EnableFacebookScreen];
    }
    else
    {
        // tell delegate we're done
        [wizardDelegate showNextScreen:mainClockScreen FromCurrentScreen:welcome3EnableFacebookScreen];
    }
}

@end
