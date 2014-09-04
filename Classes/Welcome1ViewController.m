//
//  Welecome1ViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "Welcome1ViewController.h"
#import "ViewHelper.h"
#import "WizardDelegate.h"
#import "SoundDirector.h"
#import "Flurry.h"
#import "PrivacyPolicyViewController.h"

@implementation Welcome1ViewController

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
    [sd sayWelcomeWizard];
    
    [Flurry logEvent:@"wizard1"];
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


-(IBAction)nextBtnFromScreen1Clicked:(id)sender
{
    ViewHelper *vh = [ViewHelper sharedManager];

    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
    
   
}

-(void)finishAnimationComplete
{
     [self.view removeFromSuperview];
    // tell delegate we're done
    [wizardDelegate showNextScreen:welcome2EnterNameScreen FromCurrentScreen:welcome1Screen];
}


@end
