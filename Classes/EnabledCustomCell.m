//
//  EnabledCustomCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EnabledCustomCell.h"
#import "AlarmsModel.h"

@implementation EnabledCustomCell
@synthesize toggleSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
	[toggleSwitch setOn:sharedManager.selectedAlarm.enabled];
}

-(IBAction) switchValueChanged:(id)sender {
	
	AlarmsModel *sharedManager = [AlarmsModel sharedManager];
		
	if ([sender isOn]) {
        [[sharedManager selectedAlarm] setEnabled:YES];
    } 
    else {
        [[sharedManager selectedAlarm] setEnabled:NO];
    }
	
	[sharedManager saveAlarms];
	
}




@end
