//
//  SnoozeLengthCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SnoozeLengthCell.h"
#import "UserModel.h"


@implementation SnoozeLengthCell
@synthesize snoozeLengthLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		UserModel *userModel = [UserModel userModel];
		snoozeLengthLbl.text = [NSString stringWithFormat:@"%d minutes", userModel.userSettings.snoozeLength];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
	UserModel *userModel = [UserModel userModel];
	snoozeLengthLbl.text = [NSString stringWithFormat:@"%d minutes", userModel.userSettings.snoozeLength];
}




@end
