//
//  WeatherView.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeatherView.h"
#import "SoundDirector.h"
#import "UserModel.h"
#import "WeatherModel.h"

@implementation WeatherView
- (id)init {
	CGRect frame = CGRectMake(0, 0, 100, 50);
	
	if ( self = [self initWithFrame:frame] ) {
		self.opaque = NO;
	}
	return self;
}
/*- (CGGradientRef)getGradient
{
	CGColorSpaceRef myColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 0.5, 0.4, 0.3,  // Start color
		0.8, 0.8, 0.3, 0.6 }; // End color
	
	
	myColorspace = CGColorSpaceCreateDeviceRGB();
	return CGGradientCreateWithColorComponents (myColorspace, components,
												locations, num_locations);
}

- (void)drawRect:(CGRect)rect 
{
	//  [super drawRect:rect];
	
    return;
    
    UserModel *userModel = [UserModel userModel];
    if ([userModel.userSettings.themeName isEqualToString:@"High Contrast"])
	{
        
        return;
    }
    
    CGGradientRef gradient = [self getGradient];
	
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    CGMutablePathRef outlinePath = CGPathCreateMutable(); 
    float offset = 5.0;
    float w  =[self bounds].size.width; 
    float h  =  [self bounds].size.height; 
    CGPathMoveToPoint(outlinePath, nil, offset*2.0, offset); 
    CGPathAddArcToPoint(outlinePath, nil, offset, offset, offset, offset*2, offset); 
    CGPathAddLineToPoint(outlinePath, nil, offset, h - offset*2.0); 
    CGPathAddArcToPoint(outlinePath, nil, offset, h - offset, offset *2.0, h-offset, offset); 
    CGPathAddLineToPoint(outlinePath, nil, w - offset *2.0, h - offset); 
    CGPathAddArcToPoint(outlinePath, nil, w - offset, h - offset, w - offset, h - offset * 2.0, offset); 
    CGPathAddLineToPoint(outlinePath, nil, w - offset, offset*2.0); 
    CGPathAddArcToPoint(outlinePath, nil, w - offset , offset, w - offset*2.0, offset, offset); 
    CGPathCloseSubpath(outlinePath); 
	
    CGContextSetShadow(ctx, CGSizeMake(4,4), 3); 
    CGContextAddPath(ctx, outlinePath); 
    CGContextFillPath(ctx); 
	
    CGContextAddPath(ctx, outlinePath); 
    CGContextClip(ctx);
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
	
    CGPathRelease(outlinePath);
}

- (CGGradientRef)normalGradient
{
	
    NSMutableArray *normalGradientLocations = [NSMutableArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0f],
                                               [NSNumber numberWithFloat:1.0f],
                                               nil];
	
	
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
	
    UIColor *color = [UIColor colorWithRed:0.2745 green:0.2745 blue:0.2745 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    color = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    NSMutableArray  *normalGradientColors = colors;
	
    int locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++)
    {
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (CFArrayRef)normalGradientColors, locations);
    CGColorSpaceRelease(space);
	
    return normalGradient;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}*/

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// draw box without shadow
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// draw box with shodow
	
	// play time
	SoundDirector *soundDirector = [SoundDirector soundDirector];
    
    UserModel *um = [UserModel userModel];
    
    
    // if the user is paid, and not offline, then fetch the speech for the text (narrtive) weather description
    if (um.userSettings.isPaidUser && !um.userSettings.isOfflineMode)
    {
        // fetch the sounds in a new thread - TODO make weather forecast better
       /* WeatherModel *wm = [WeatherModel weatherModel];
        SoundDirector *sd = [SoundDirector soundDirector];
        if (sd.isEvening)
        {
            [wm getVoiceForTextWeatherTomorrowAndReturnTo:self];	
        }
        else {
            [wm getVoiceForTextWeatherTodayAndReturnTo:self];	
        }*/
        
         [soundDirector playWeather:TRUE];
    }
    else {
        [soundDirector playWeather:TRUE];
    }
    
	
	
	
}

-(void)weatherSpeechGenerated;
{
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */



@end