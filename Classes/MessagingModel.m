//
//  MessagingModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MessagingModel.h"
#import "MessageVO.h"
#import "AddMessageService.h"
#import "MessageReadService.h"
#import "UserModel.h"
#import "FacebookUser.h"
#import "RecentlyUsedMesageRecipient.h"
#import "GetUnreadMessagesCountDelegate.h"
#import "GetUnreadMessageCountService.h"

static MessagingModel *sharedMyManager = nil;

@implementation MessagingModel

@synthesize targetFriends;
@synthesize messagesToPlay;
@synthesize recentlyUsedRecipients;
@synthesize messagesCountService;
@synthesize recordFilePathForComposeMessageVoice;

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
	
	targetFriends = [[NSMutableArray alloc] initWithObjects:nil];
	messagesToPlay = [[NSMutableArray alloc] initWithObjects:nil];
	
    [self loadRecentlyUsedRecipientsList];
	
    return self;
}

-(void)loadRecentlyUsedRecipientsList {
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	// DEBUG  - clear settings below
	//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserThemes"];
	
	
	NSData *myEncodedObject = [currentDefaults objectForKey:@"kRecentlyUsedRecipients"];
	NSMutableArray* recentlyUsedRecipientsSaved = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	
	if (recentlyUsedRecipientsSaved != nil)
		[self setRecentlyUsedRecipients:recentlyUsedRecipientsSaved];
	else
	{
		[self setRecentlyUsedRecipients:[[NSMutableArray alloc] init]];
		[self saveRecentlyUsedRecipients];
	}
}

-(void)saveRecentlyUsedRecipients {
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[self recentlyUsedRecipients]] forKey:@"kRecentlyUsedRecipients"];
	[[NSUserDefaults standardUserDefaults]  synchronize];
	
}

-(RecentlyUsedMesageRecipient *)getUserWithFromRecentlyUsedWithFBID:(NSNumber *)uid {
    
    for (RecentlyUsedMesageRecipient *user in recentlyUsedRecipients)
    {
        if ([user.fbID isEqualToNumber:uid])
        {
            return user;
        }
    }
    
    return nil;
    
}

-(void)addToRecentlyUsedRecipients:(FacebookUser *) fbUser {
    
    // check to see if a user with that facebook id is already in the list
    RecentlyUsedMesageRecipient *match =  [self getUserWithFromRecentlyUsedWithFBID:fbUser.uid];
    
    // if so, remove him (they will be readded)
    if (match)
    {
        [recentlyUsedRecipients removeObject:match];
    }
    
    RecentlyUsedMesageRecipient *user = [[RecentlyUsedMesageRecipient alloc] init];
    user.fbID = fbUser.uid;
    user.dateUsed = [NSDate date];
    
    [recentlyUsedRecipients addObject:user];
}


- (void)saveMessageAsRead:(MessageVO *)message {

	UserModel *userModel = [UserModel userModel];
	MessageReadService *messagingService = [[MessageReadService alloc] init];
	[messagingService markMessageRead:message.messageBodyID andUserID:userModel.userSettings.fbID];
    
    [messagesToPlay removeObject:message];

}

-(void)refreshMessagesCount:(id <GetUnreadMessagesCountDelegate>)delegateClass
{
    UserModel *userModel = [UserModel userModel];
    self.messagesCountService = [[GetUnreadMessageCountService alloc] init];
    [messagesCountService  fetchUnreadMessagesCount:userModel.userSettings.fbID AndReturnTo:delegateClass];
}


@end
