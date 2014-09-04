//
//  Theme.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Theme : NSObject <NSCoding> {
	NSString *themeName;
	NSString *imageName;
	NSString *imageDescription;
	NSString *textColor;
	NSString *style;
	NSString *thumbnailImage;
	BOOL isUserTheme;
}


@property (nonatomic, strong) NSString *themeName;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *imageDescription;
@property (nonatomic, strong) NSString *textColor;
@property (nonatomic, strong) NSString *style;
@property (nonatomic) BOOL isUserTheme;
@property (nonatomic, strong) NSString *thumbnailImage;

/* Conform with NSCoding protocol */
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
