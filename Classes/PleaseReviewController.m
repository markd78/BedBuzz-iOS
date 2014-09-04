//
//  PleaseReviewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/9/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "PleaseReviewController.h"
#import "ViewHelper.h"
#import "Flurry.h"

@implementation PleaseReviewController

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
}

- (IBAction)yesClicked:(id)sender
{
    [Flurry logEvent:@"please review - yes"];
    
    // dismiss the wizard
    ViewHelper *vh = [ViewHelper sharedManager];
    
    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:nil];
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=488672934"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=471420357"]];
    }
    
}
- (IBAction)noClicked:(id)sender
{
    [Flurry logEvent:@"please review - no"];
    
    ViewHelper *vh = [ViewHelper sharedManager];
    
    [vh moveToEndPosition:vh.currentView ForOrientation:[UIApplication sharedApplication].statusBarOrientation AndReturnTo:self];
}

@end
