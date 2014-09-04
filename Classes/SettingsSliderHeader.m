//
//  SettingsSliderHeader.m
//  SpeakAlarm
//
//  Created by Mark Davies on 11/30/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "SettingsSliderHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "TableViewHeaderDelegate.h"
#import "UserModel.h"

@implementation SettingsSliderHeader
@synthesize delegate;

- (id)initWithCallback:(id <TableViewHeaderDelegate>)delegateClass {
    
    self.delegate  = delegateClass;
    
    UserModel *um = [UserModel userModel];
    CGRect frame;
    
    if (um.userSettings.isPaidUser)
    {
        frame = CGRectMake(20, 0, 200, 65);
    }
	else {
        frame = CGRectMake(20, 0, 200, 100);
    }
    
	
    
    
	if ( self = [self initWithFrame:frame] ) {
		self.opaque = NO;
	}
	return self;
}

-(void)subscribePressed
{
    [delegate subscribeBtnPressed];
}

-(void)animateSubscribeBtn:(UIButton *)btn
{
    btn.alpha = 0.4;
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; //delete "EaseOut", then push ESC to check out other animation styles
	[UIView setAnimationDuration: 0.8];//how long the animation will take
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:INFINITY];
	[UIView setAnimationDelegate: self];
    btn.alpha = 1.0;//1.0 to make it visible or 0.0 to make it invisible
	[UIView commitAnimations];
}

- (id) initWithFrame:(CGRect) frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        // Setup your image view and add it to the view.
        
        float yPos=12;
        
        UserModel *um = [UserModel userModel];
        
        if (!um.userSettings.isPaidUser)
        {
            
            UIButton *subscribeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [subscribeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [subscribeBtn setBackgroundColor:[UIColor yellowColor]];
            [subscribeBtn setBackgroundImage:[UIImage imageNamed:@"buttonRed"] forState: UIControlStateSelected];
            
            subscribeBtn.layer.borderColor = [UIColor blackColor].CGColor;
            subscribeBtn.layer.borderWidth = 0.5f;
            subscribeBtn.layer.cornerRadius = 10.0f;
            
            [subscribeBtn setFrame:CGRectMake(10,yPos,300,35)];
            [subscribeBtn setTitle:@"Press here to Upgrade now!" forState:UIControlStateNormal] ;
            [subscribeBtn setHighlighted:YES];
            [subscribeBtn addTarget:self 
                             action:@selector(subscribePressed)
                   forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:subscribeBtn];
            [self animateSubscribeBtn:subscribeBtn];
            
            yPos += 40;
        }
        
        //if ios5 - show brightness control
        if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
        {
        // Setup your label
        UILabel *myLabel = [[UILabel alloc] initWithFrame:frame];
        myLabel.frame = CGRectMake(18, yPos, 200, 20);
        myLabel.text = @"Screen Brightness:";
        myLabel.backgroundColor = [UIColor clearColor];
        // myLabel.textColor = [UIColor colorWithHue:0.59 saturation:0.29 brightness:0.47 alpha:1.0];
        myLabel.textColor = [UIColor colorWithHue:0.59 saturation:0.29 brightness:0.25 alpha:1.0];
        
        //myLabel.textColor = [UIColor whiteColor];
        myLabel.shadowColor = [UIColor whiteColor];
        myLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        myLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:myLabel];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(20, yPos + 13, 260, 50);
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        slider.tag = 0;
        slider.value = [[UIScreen mainScreen] brightness];
        slider.continuous = YES;
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:slider];
        }
    }
    return self;
}

- (void)sliderAction:(UISlider*)sender
{
    [[UIScreen mainScreen] setBrightness:[sender value]];
}
@end
