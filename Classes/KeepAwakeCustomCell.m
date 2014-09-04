//
//  KeepAwakeCustomCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 12/2/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "KeepAwakeCustomCell.h"
#import "UserModel.h"

@implementation KeepAwakeCustomCell
@synthesize toggleSwitch;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
	UserModel *userModel = [UserModel userModel];
	[toggleSwitch setOn:userModel.userSettings.isKeepAwakeOn];
}

-(IBAction) switchValueChanged:(id)sender {
	
	UserModel *userModel = [UserModel userModel];
	
	if ([sender isOn]) {
        userModel.userSettings.isKeepAwakeOn = YES;
    } 
    else {
        userModel.userSettings.isKeepAwakeOn = NO;
    }
	
	[userModel saveUserSettings];
	
}



@end
