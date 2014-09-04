//
//  ThemesModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "Theme.h"

@interface ThemesModel : NSObject {
	NSMutableArray *themes;
	NSMutableArray *userThemes;
}

+ (ThemesModel*) sharedInstance;
-(void)addHardCodeThemes;
-(void)addNewUserTheme:(Theme *) userTheme;
-(void)addUserThemes;
-(void)loadUserThemes;
-(void)saveUserThemes;

@property (nonatomic,strong) NSMutableArray *themes;
@property (nonatomic,strong) NSMutableArray *userThemes;
@end
