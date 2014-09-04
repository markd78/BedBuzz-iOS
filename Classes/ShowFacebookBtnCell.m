//
//  ShowFacebookBtnCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "ShowFacebookBtnCell.h"
#import "UserModel.h"

@implementation ShowFacebookBtnCell
@synthesize toggleSwitch;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
	UserModel *userModel = [UserModel userModel];
	[toggleSwitch setOn:userModel.userSettings.hideFacebookBtn];
}

-(IBAction) switchValueChanged:(id)sender {
	
	UserModel *userModel = [UserModel userModel];
	
	if ([sender isOn]) {
        userModel.userSettings.hideFacebookBtn = YES;
    } 
    else {
        userModel.userSettings.hideFacebookBtn = NO;
    }
	
	[userModel saveUserSettings];
	
}



@end
