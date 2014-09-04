
#import "FacebookModel.h"
#import "FacebookLoggedInDelegate.h"
#import "FacebookGotUserNameDelegate.h"
#import "FacebookUser.h"
#import "FetchMessagesService.h"
#import "UserModel.h"
#import "MessagingModel.h"
#import "FacebookGotFriendsDelegate.h"
#import "UpdateUsersFacebookIDService.h"
#import "SpeakAlarmAppDelegate.h"
#import "LoginService.h"

static FacebookModel *sharedMyManager = nil;

@implementation FacebookModel

@synthesize kAppId;
@synthesize friendsList;
@synthesize friendsListWithBedBuzz;
@synthesize friendsListRecentlyUsed;
@synthesize friendsDict;
@synthesize facebook;
@synthesize firstName;
@synthesize isFetchingID;

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
	
	kAppId = @"144317305656742";
	
	isGettingFriends = NO;
    
    gotUserName = NO;
	
    friendsDict = [[NSMutableDictionary alloc] init];
    
	return self;
}

/**
 * Login/out button click
 */	
- (void) fbLoginAndReturnTo:(id <FacebookLoggedInDelegate>)delegateClass {
	
    
    facebookLoggedInDelegate = delegateClass;
    
    facebook = [[Facebook alloc] initWithAppId:kAppId urlSchemeSuffix:@"bedbuzzscheme"  andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AccessToken"] 
        && [defaults objectForKey:@"ExpirationDate"]) {
        facebook.accessToken = [defaults objectForKey:@"AccessToken"];
        facebook.expirationDate = [defaults objectForKey:@"ExpirationDate"];
    }
    
    if ([facebook isSessionValid]) {
        isFetchingID = YES;
		[facebook requestWithGraphPath:@"me" andDelegate:self];
	}
	else {
        //  [facebook authorize:_permissions delegate:self];
        [facebook authorize:nil];
	}
    
    
}




- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"AccessToken"];
    [defaults setObject:[facebook expirationDate] forKey:@"ExpirationDate"];
    [defaults synchronize];
    
    UserModel *userModel = [UserModel userModel];
    if (userModel.userSettings.fbID == nil || [userModel.userSettings.fbID intValue] == -1)
    {
        // get the fb id and friends
        [facebook requestWithGraphPath:@"me" andDelegate:self];
        [self getFacebookFriendsAndReturnTo:nil];
    }
    
    [facebookLoggedInDelegate facebookLoggedIn];
    
    
}

// Method that gets called when the request dialog button is pressed
- (void)requestDialog:(NSMutableArray *)toUsers {
    
    NSString * toUsersStr = [[toUsers valueForKey:@"description"] componentsJoinedByString:@","];
    
    UserModel *userModel = [UserModel userModel];
    NSString *messageTitle = [userModel.userFirstNameFromFB stringByAppendingString:@" sent you a wake up message!"];
    
    
    
    NSString *messageBody = [userModel.userFirstNameFromFB stringByAppendingString:@"a wake up message using BedBuzz.  Click here to use BedBuzz and hear your message during your next alarm!"];
    
    NSMutableDictionary* params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     messageTitle,  @"message",
     messageBody, @"notification_text",
     toUsersStr, @"to",
     nil];  
    [facebook dialog:@"apprequests"
           andParams:params
         andDelegate:self];
}

// FBDialogDelegate
- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"dialog completed successfully");
}

/**
 * Callback for facebook did not login
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/**
 * Callback for facebook logout
 */ 
-(void) fbDidLogout {
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Callback when a request receives Response
 */ 
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
	NSLog(@"received response");
};

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
	
	NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
};


-(void)redirectMethod:(id)sender {
	
}

/*-(void)getMessageToPost
 {
 fService = [[FetchFacebookMessage alloc] init];
 [fService getFacebookMessageAndReturnTo:self];
 }*/

/*-(void)facebookMessageHasBeenFetched:(NSString *)message
 {
 [self postUsingBedBuzzMessageToWall:message];
 [fService release];
 }*/

/*-(void)postUsingBedBuzzMessageToWall:(NSString *)message
 {
 NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
 message, @"message",
 @"https://bedbuzzserver.appspot.com/icon.png", @"picture",
 @"BedBuzz - FREE talking alarm clock", @"name",
 @"http://www.comantis.com/bedBuzz/", @"link",
 @"With BedBuzz you can wake up to your personalized greeting, hear messages from your friends, & get the weather forecast and news, all without getting out of bed!", @"description",
 nil];
 
 [facebook requestWithGraphPath: @"me/feed"
 andParams:params
 andHttpMethod:@"POST"
 andDelegate:self];
 
 }*/

-(void)getNameOfUserAndReturnTo:(id <FacebookGotUserNameDelegate>) delegateClass
{
    NSLog(@"Getting name of user from facebook");
	facebookGotUserNameDelegate = delegateClass;
	// save access token so next time we login we can use this for auto logon
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:@"ExpirationDate"];
	
	// to get the user id we need to call below - per https://github.com/facebook/facebook-ios-sdk/wiki
	[facebook requestWithGraphPath:@"me" andDelegate:self];	
}

/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on thee format of the API response.
 */
- (void)request:(FBRequest*)request didLoad:(id)result {	
	
    NSArray* users = result;
    
	if (! [users respondsToSelector: @selector(addObject:)])
	{
        if (!gotUserName)
        {
            
            UserModel *userModel = [UserModel userModel];
            BOOL needToRelogin = NO;
            
            if (userModel.userSettings.fbID == nil  || [userModel.userSettings.fbID longValue]==-1 || [userModel.userSettings.bedBuzzID longValue]== -1)
            {
                needToRelogin = YES; 
            }
            
            gotUserName= YES;
            
            // get the user's facebook id
            NSString *fbID = [result objectForKey:@"id"];
            
            myfbID = fbID;
            
            firstName = [result objectForKey:@"first_name"]; 
            
            userModel.userFirstNameFromFB = firstName;
            
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * fbIDNum = [f numberFromString:fbID];
            userModel.userSettings.fbID = fbIDNum;
            
            [userModel saveUserSettings];
            
            [facebookGotUserNameDelegate facebookGotUserName:firstName andID:fbID];
            
            SpeakAlarmAppDelegate *appDelegate = (SpeakAlarmAppDelegate*)[[UIApplication sharedApplication] delegate];
            
            [appDelegate showSendFirstMessageDialog];
            
            isFetchingID = NO;
            
            if (needToRelogin)
            {
                // can now log in with the ID
                LoginService *loginService = [[LoginService alloc] init];
                [loginService logOnUserWithBedBuzzID:userModel.userSettings.bedBuzzID andFBID:userModel.userSettings.fbID  AndReturnTo:nil];
            }
        }
		
		
	}
	else {
		if(friendsList==nil) {
			
            MessagingModel *messagingModel = [MessagingModel sharedManager];
            
			// initialize the friends list
			friendsList = [[NSMutableArray alloc] init];
			
			friendsListWithBedBuzz = [[NSMutableArray alloc] init];
			
            friendsListRecentlyUsed = [[NSMutableArray alloc] init];
            
			
			for(NSInteger i=0;i<[users count];i++) 
			{
				NSDictionary* user = [users objectAtIndex:i];				
				FacebookUser *fbUser = [[FacebookUser alloc] init];
				fbUser.uid = [user objectForKey:@"uid"];
				fbUser.name = [user objectForKey:@"name"];
				fbUser.picSmallURL = [user objectForKey:@"pic_square"];
				
                //  UIImage *friendPic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:fbUser.picSmallURL]]];
                
                //  [friendsPicsDict setObject:friendPic forKey:fbUser.uid]; 
                
				NSNumber* isAppUser = [user objectForKey:@"is_app_user"];
				if ([isAppUser isEqualToNumber: [NSNumber numberWithInt:1]])
				{
					fbUser.isBedBuzzUser = YES;
				}
				else {
					fbUser.isBedBuzzUser = NO;
				}
				
				[friendsList addObject:fbUser];
				
				if (fbUser.isBedBuzzUser)
				{
					[friendsListWithBedBuzz addObject:fbUser];	
				}
                
                if ([messagingModel getUserWithFromRecentlyUsedWithFBID:fbUser.uid]!=nil)
                {
                    [friendsListRecentlyUsed addObject:fbUser];	
                }
                
                [friendsDict setObject:fbUser forKey:fbUser.uid];
			}
			
			
            if (facebookGotFriendsDelegate!=nil)
            {
                [facebookGotFriendsDelegate gotFacebookFriends];
            }
		}
		
		
		
	}
    
	
}	

-(void)getFacebookFriendsAndReturnTo:(id <FacebookGotFriendsDelegate>) delegateClass {
    
    facebookGotFriendsDelegate = delegateClass;
    
	NSString *fql = [NSString localizedStringWithFormat:
					 @"SELECT uid, name,  pic_square, is_app_user FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) ORDER BY last_name",myfbID];
	
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:fql forKey:@"query"];
	[facebook requestWithMethodName: @"fql.query"
                          andParams: params
                      andHttpMethod: @"POST"
                        andDelegate: self];	
    
	
	isGettingFriends = YES;
}

-(void)clearTargetFriends
{
	for (FacebookUser *fbUser in friendsList)
	{
		fbUser.isTargetForMessage = NO;
	}
    
    for (FacebookUser *fbUser in friendsListWithBedBuzz)
	{
		fbUser.isTargetForMessage = NO;
	}
    
    for (FacebookUser *fbUser in friendsListRecentlyUsed)
	{
		fbUser.isTargetForMessage = NO;
	}
    
}

-(void) messageServiceResult:(NSString*)result
{
	
}

-(void)updateUsersFacebookIDWithFacebookID:(NSNumber *)facebookID andBedBuzzID:(NSNumber *)bedBuzzID
{
    UpdateUsersFacebookIDService *service = [[UpdateUsersFacebookIDService alloc] init];
    [service updateUsersFacebookID:bedBuzzID andFBID:facebookID];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:accessToken forKey:@"AccessToken"];
    [defaults setObject:expiresAt forKey:@"ExpirationDate"];
    [defaults synchronize];
}

@end
