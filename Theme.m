//
//  Theme.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Theme.h"


@implementation Theme

@synthesize themeName;
@synthesize imageName;
@synthesize imageDescription;
@synthesize textColor;
@synthesize style;
@synthesize thumbnailImage;
@synthesize isUserTheme;

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:themeName forKey:@"themeName"];
	[coder encodeObject:imageName forKey:@"imageName"];
	[coder encodeObject:imageDescription forKey:@"imageDescription"];
	[coder encodeObject:textColor forKey:@"textColor"];
	[coder encodeObject:style forKey:@"style"];
	[coder encodeObject:thumbnailImage forKey:@"thumbnailImage"];
	[coder encodeBool:isUserTheme forKey:@"isUserTheme"];}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Theme alloc] init];
    if (self != nil)
    {
        self.themeName = [coder decodeObjectForKey:@"themeName"];
		self.imageName = [coder decodeObjectForKey:@"imageName"];
		self.imageDescription = [coder decodeObjectForKey:@"imageDescription"];
		self.textColor = [coder decodeObjectForKey:@"textColor"];
		self.style = [coder decodeObjectForKey:@"style"];
		self.thumbnailImage = [coder decodeObjectForKey:@"thumbnailImage"];
		self.isUserTheme = [coder decodeBoolForKey:@"isUserTheme"];
    }   
    return self;
}

@end
