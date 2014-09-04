//
//  FacebookUser.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/19/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FacebookUser : NSObject {
	NSString *name;
	NSString *picSmallURL;
	NSNumber *uid;
	BOOL isBedBuzzUser;
	BOOL isTargetForMessage;
    BOOL isRecentlyUsed;
    NSDate *dateAddedToRecentlyUsed;
}

@property (nonatomic) BOOL isTargetForMessage;
@property (nonatomic) BOOL isBedBuzzUser;
@property (nonatomic) BOOL isRecentlyUsed;
@property (nonatomic, strong) NSDate *dateAddedToRecentlyUsed;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *picSmallURL;
@property (nonatomic, strong) NSNumber *uid;

@end
