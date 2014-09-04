//
//  AlarmNameCustomCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmNameCustomCell.h"
#import "AlarmsModel.h"

@implementation AlarmNameCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		AlarmsModel *sharedManager = [AlarmsModel sharedManager];
		[alarmNameTextField setText:sharedManager.selectedAlarm.alarmName];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	[alarmNameTextField setText:sharedManager.selectedAlarm.alarmName];
    // Configure the view for the selected state.
}



- (IBAction)dismissKeyboard:(id)sender {
	
    [sender resignFirstResponder];
	
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	[[sharedManager selectedAlarm] setAlarmName:[sender text]];
	[sharedManager saveAlarms];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [alarmNameTextField resignFirstResponder];
    return YES;
}


@end
