//
//  RootViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 11/13/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "RootViewController_Old.h"

@implementation RootViewController_Old

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fromAlarmNotification:(BOOL)fromAlarm
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isFromAlarm = fromAlarm;
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

-(void)repositionControls
{
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;    
        BOOL isLandscape = UIDeviceOrientationIsLandscape(orientation);
        
        if  (!isLandscape)
        {
            loggingOnLbl.frame = CGRectMake(300, 600, 300, 130);
            spinner.frame = CGRectMake(400, 750, 100, 100);
            imageView.frame = CGRectMake(150, 100, 512, 512);
        }
        else
        {
            loggingOnLbl.frame = CGRectMake(636, 257, 300, 130);
            spinner.frame = CGRectMake(701, 452, 100, 100);
            imageView.frame = CGRectMake(43, 156, 512, 512);

        }
    }
    
}



- (void)viewDidLoad
{
   if (isFromAlarm)
   {
       imageView.hidden = YES;
       loggingOnLbl.hidden = YES;
       spinner.hidden = YES;
   }

    [self repositionControls];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self repositionControls];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return YES;
}

@end
