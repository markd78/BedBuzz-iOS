//
//  UserModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface UserModel : NSObject {
	Settings *userSettings;
    NSString *userFirstNameFromFB;
	
}

+ (id)userModel;
-(void)loadUserSettings;
-(void)saveUserSettings;
@property (nonatomic,strong) Settings *userSettings;
@property (nonatomic,strong) NSString *userFirstNameFromFB;

@end
