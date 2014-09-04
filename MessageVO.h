//
//  TTSMessage.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/31/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageVO : NSObject {
	NSString *messageText;
	NSMutableArray *targets;
	NSString *voiceName;
	NSDate *targetDate;
	NSNumber *senderID;
	NSData *sound;
	NSNumber *messageBodyID;
	BOOL isRead;
}

	@property (nonatomic, strong) NSString *messageText;
	@property (nonatomic, strong) NSString *voiceName;
	@property (nonatomic, strong) NSDate *targetDate;
	@property (nonatomic, strong) NSMutableArray *targetIDs;
	@property (nonatomic, strong) NSNumber *senderID;
	@property (nonatomic, strong) NSData *sound;
	@property (nonatomic, strong) NSNumber *messageBodyID;
	@property (nonatomic) BOOL isRead;
@end
