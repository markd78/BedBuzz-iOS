//
//  Model.h
//  
//
//  Created by Mark Davies on 8/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "FacebookLoggedInDelegate.h"
#import "FacebookGotUserNameDelegate.h"
#import "MessagingServiceDelegate.h"
#import "FacebookGotFriendsDelegate.h"
#import "FetchFacebookMessageDelegate.h"
#import "FetchFacebookMessage.h"

@interface FacebookModel : NSObject <FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate, MessagingServiceDelegate, FetchFacebookMessageDelegate> 
{
    FetchFacebookMessage* fService;
	NSString *kAppId;
	NSString *myfbID;
    NSString *firstName;
	bool isGettingFriends;
    bool isFetchingID;
    bool gotUserName;
	id <FacebookLoggedInDelegate> facebookLoggedInDelegate;
	id <FacebookGotUserNameDelegate> facebookGotUserNameDelegate;
    id <FacebookGotFriendsDelegate> facebookGotFriendsDelegate;
	NSMutableArray *friendsList;
	NSMutableArray *friendsListWithBedBuzz;
    NSMutableArray *friendsListRecentlyUsed;
    
    NSMutableDictionary *friendsDict;
}

@property (nonatomic, strong) NSString *kAppId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSMutableArray *friendsList;
@property (nonatomic, strong) NSMutableArray *friendsListWithBedBuzz;
@property (nonatomic, strong) NSMutableArray *friendsListRecentlyUsed;
@property (nonatomic, strong) NSMutableDictionary *friendsDict;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic) bool isFetchingID;

+ (id)sharedManager;
- (void) fbLoginAndReturnTo:(id <FacebookLoggedInDelegate>)delegateClass;
//-(void)postUsingBedBuzzMessageToWall:(NSString *)message;
-(void)getNameOfUserAndReturnTo:(id <FacebookGotUserNameDelegate>) delegateClass;
-(void)getFacebookFriendsAndReturnTo:(id <FacebookGotFriendsDelegate>) delegateClass;
-(void)clearTargetFriends;
//-(void)facebookMessageHasBeenFetched:(NSString *)message;
//-(void)getMessageToPost;
-(void)updateUsersFacebookIDWithFacebookID:(NSNumber *)facebookID andBedBuzzID:(NSNumber *)bedBuzzID;
-(void)requestDialog:(NSMutableArray *)toUsers;
@end
