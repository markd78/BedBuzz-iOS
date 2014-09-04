//
//  RSSFeed.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RSSFeed : NSObject <NSCoding> {
	NSString *feedName;
	NSString *feedLink;
	NSString *voiceName;
    BOOL enabled;
}

@property (nonatomic, strong) NSString *feedName;
@property (nonatomic, strong) NSString *feedLink;
@property (nonatomic, strong) NSString *voiceName;
@property (nonatomic) BOOL enabled;

/* Conform with NSCoding protocol */
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;



@end
