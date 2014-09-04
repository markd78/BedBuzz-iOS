//
//  AlarmsModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageVO.h"
#import "FacebookUser.h"
#import "RecentlyUsedMesageRecipient.h"
#import "GetUnreadMessageCountService.h"

@interface MessagingModel : NSObject {
	
	NSMutableArray *targetFriends;
	NSMutableArray *messagesToPlay;
    GetUnreadMessageCountService *messagesCountService;
    NSString*					recordFilePathForComposeMessageVoice;	
	
}

@property (nonatomic, strong) NSMutableArray *targetFriends;
@property (nonatomic, strong) NSMutableArray *messagesToPlay;
@property (nonatomic,strong) NSMutableArray *recentlyUsedRecipients;
@property (nonatomic,strong)  GetUnreadMessageCountService *messagesCountService;
@property (nonatomic, strong)  NSString *recordFilePathForComposeMessageVoice;

+ (id)sharedManager;
-(void)saveMessageAsRead:(MessageVO *)message;
-(void)saveRecentlyUsedRecipients;
-(void)loadRecentlyUsedRecipientsList;
-(void)addToRecentlyUsedRecipients:(FacebookUser *) fbUser;
-(RecentlyUsedMesageRecipient *)getUserWithFromRecentlyUsedWithFBID:(NSNumber *)uid;
-(void)refreshMessagesCount:(id <GetUnreadMessagesCountDelegate>)delegateClass;
@end
