//
//  CustomSlider.m
//  SpeakAlarm
//
//  Created by Mark Davies on 12/2/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "CustomSlider.h"

#define THUMB_SIZE 10
#define EFFECTIVE_THUMB_SIZE 20

@implementation CustomSlider

- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, -10, -8);
    return CGRectContainsPoint(bounds, point);
}

- (BOOL) beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    float thumbPercent = (self.value - self.minimumValue) / (self.maximumValue - self.minimumValue);
    float thumbPos = THUMB_SIZE + (thumbPercent * (bounds.size.width - (2 * THUMB_SIZE)));
    CGPoint touchPoint = [touch locationInView:self];
    return (touchPoint.x >= (thumbPos - EFFECTIVE_THUMB_SIZE) && touchPoint.x <= (thumbPos + EFFECTIVE_THUMB_SIZE));
}

@end
