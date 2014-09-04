//
//  ViewHelper.m
//  SpeakAlarm
//
//  Created by Mark Davies on 2/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "ViewHelper.h"
#import <QuartzCore/CALayer.h>
#import "WizardAnimationDelegate.h"

static ViewHelper *sharedMyManager = nil;

@implementation ViewHelper
@synthesize currentView;
@synthesize currentViewIsInCenter;

#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedMyManager == nil)
			sharedMyManager = [[super allocWithZone:NULL] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	return self;
}

-(CGRect)getCenterPositionForView:(UIView *)v ForOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewWidth =  v.bounds.size.width;
    CGFloat viewHeight = v.bounds.size.height; 
    CGRect frame;
    // Return YES for supported orientations
   // if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
   //    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
   // {
        
        if (UIDeviceOrientationIsLandscape(toInterfaceOrientation))
        {
            frame = CGRectMake((screenHeight - viewWidth ) / 2, (screenWidth - viewHeight ) / 2, viewWidth, viewHeight);
        }
        else
        {
            frame = CGRectMake((screenWidth -viewWidth) / 2, (screenHeight - viewHeight) / 2, viewWidth, viewHeight);
        }
   /* }
    else
    {
       frame = CGRectMake((screenHeight - viewWidth) / 2, (screenWidth - viewHeight- 20) / 2, viewWidth, viewHeight);
       
    }
    */
    
    
    return frame;
}

-(UIView *)moveToStartPosition:(UIView *)v ForOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    currentViewIsInCenter = YES;
    currentView = v;
    [v setHidden:NO];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewWidth =  v.bounds.size.width;
    CGFloat viewHeight = v.bounds.size.height; 
    
    CGRect center = [self getCenterPositionForView:v ForOrientation:toInterfaceOrientation];
    CGFloat viewX =   center.origin.x;
    CGFloat viewY =  center.origin.y;
   // if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
   //    UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
   // {
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation))
    {
        v.frame = CGRectMake(((screenHeight - viewWidth) / 2) +(screenHeight/2+viewWidth/2), (screenWidth - viewHeight) / 2, viewWidth, viewHeight);
    }
    else
    {
        v.frame = CGRectMake(((screenWidth -viewWidth) / 2)+(screenWidth /2+viewWidth/2), (screenHeight - viewHeight) / 2, viewWidth, viewHeight);
    }
   /* }
    else
    {
         v.frame = CGRectMake(((screenHeight - viewWidth) / 2) +(screenHeight/2+viewWidth/2), (screenWidth - viewHeight - 20) / 2, viewWidth, viewHeight);
    }*/
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation))
    {
        v.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    }
    else
    {
        v.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
    }
    
    [UIView commitAnimations];
    
    return v;
}

-(UIView *)moveToEndPosition:(UIView *)v ForOrientation:(UIInterfaceOrientation)toInterfaceOrientation AndReturnTo:(id <WizardAnimationDelegate>)delegateClass

{
    currentViewIsInCenter = NO;
    wizardDelegate = delegateClass;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewWidth =  v.bounds.size.width;
    CGFloat viewHeight = v.bounds.size.height; 
    
    CGFloat viewX =   v.frame.origin.x;
    
    [UIView beginAnimations:nil context:(__bridge void *)(v)];
    [UIView  setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector (animationDidStop:finished:context:) ];
	
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
   
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation))
    {
        v.frame = CGRectMake(viewX -(screenHeight/2+viewWidth/2), (screenWidth - viewHeight) / 2, viewWidth, viewHeight);
    }
    else
    {
        v.frame = CGRectMake(viewX-(screenWidth /2+viewWidth/2), (screenHeight - viewHeight) / 2, viewWidth, viewHeight);
    }
  
    
    
    [UIView commitAnimations];
    
    return v;
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [wizardDelegate finishAnimationComplete]; 
    UIView *view = (__bridge UIView *) context;
    [view setHidden:YES];
    
}

-(UIView *)formatTheViewForDarkWizard:(UIView *)v
{
    [v setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.7]];
    [v.layer setCornerRadius:30.0f];
    [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [v.layer setBorderWidth:1.5f];
    [v.layer setShadowColor:[UIColor blackColor].CGColor];
    [v.layer setShadowOpacity:0.8];
    [v.layer setShadowRadius:3.0];
    [v.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return v;
}

-(UIView *)formatTheViewForWizard:(UIView *)v
{
    [v setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.3]];
    [v.layer setCornerRadius:30.0f];
    [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [v.layer setBorderWidth:1.5f];
    [v.layer setShadowColor:[UIColor blackColor].CGColor];
    [v.layer setShadowOpacity:0.8];
    [v.layer setShadowRadius:3.0];
    [v.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    return v;
}

@end
