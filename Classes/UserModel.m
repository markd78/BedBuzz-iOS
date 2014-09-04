//
//  UserModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "UserModel.h"

static UserModel *sharedMyManager = nil;

@implementation UserModel
@synthesize userFirstNameFromFB;
@synthesize userSettings;

#pragma mark Singleton Methods
+ (id)userModel {
	@synchronized(self) {
		if(sharedMyManager == nil)
			sharedMyManager = [[super allocWithZone:NULL] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self userModel];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	return self;
}

-(void)loadUserSettings {
	NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
	// DEBUG  - clear settings below
	//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kUserSettings"];
	
	
	NSData *myEncodedObject = [currentDefaults objectForKey:@"kUserSettings"];
	Settings* userSettingsSaved = (Settings*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	
	if (userSettingsSaved != nil)
		[self setUserSettings:userSettingsSaved];
	else
	{
		[self setUserSettings:[[Settings alloc] init]];
		// init some settings and save
		userSettings.snoozeLength = 5;
		userSettings.isCelcius = NO;
		userSettings.userFullName = @"TESTUSER";
        
		userSettings.currentThemeImageName = @"sunrise";
        userSettings.shouldGreetWithName = YES;
        userSettings.numberOfAlarmsHappened = 0;
        
		[self saveUserSettings];
	}
	
	if ([userSettings.currentThemeImageName isEqualToString:@"Sunrise 1"])
		 {
			 userSettings.currentThemeImageName = @"sunrise";
		 }
	
	if (userSettings.bedBuzzID == nil)
	{
		userSettings.bedBuzzID = [NSNumber numberWithInt:-1];
	}
	
	if (userSettings.fbID == nil)
	{
		userSettings.fbID = [NSNumber numberWithInt:-1];
	}
    
    if (userSettings.voiceName == nil)
        {
            userSettings.voiceName= @"ukenglishfemale1";
        }
    
   }

-(void)saveUserSettings {
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[self userSettings]] forKey:@"kUserSettings"];
	[[NSUserDefaults standardUserDefaults]  synchronize];

}

@end
