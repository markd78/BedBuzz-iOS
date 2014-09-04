//
//  RedirectingToFacebookViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/12/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "RedirectingToFacebookViewController.h"
#import "ViewHelper.h"
#import "FacebookModel.h"

@implementation RedirectingToFacebookViewController

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
    
    [self performSelector:@selector(goToFacebook) withObject:nil afterDelay:4.0];
}

-(void)goToFacebook
{
    // log in with facebook
    FacebookModel *model = [FacebookModel sharedManager];
	[model fbLoginAndReturnTo:self];
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

-(void) facebookLoggedIn
{
    // dismiss the wizard
    ViewHelper *vh = [ViewHelper sharedManager];
    
    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
}

-(void)finishAnimationComplete
{
     [self.view removeFromSuperview];
    
    // tell delegate we're done
    [wizardDelegate showNextScreen:mainClockScreen FromCurrentScreen:redirectingToFacebook];
}

@end
