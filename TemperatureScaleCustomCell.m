//
//  TemperatureScaleCustomCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TemperatureScaleCustomCell.h"
#import "UserModel.h"

@implementation TemperatureScaleCustomCell
@synthesize temperatureScaleLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		// Initialization code.
		UserModel *userModel = [UserModel userModel];
		if (userModel.userSettings.isCelcius)
		{
			temperatureScaleLbl.text = @"°C";
			
		}
		else
		{
			temperatureScaleLbl.text = @"°F";
		}
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
	UserModel *userModel = [UserModel userModel];
	if (userModel.userSettings.isCelcius)
	{
		temperatureScaleLbl.text = @"°C";
		
	}
	else
	{
		temperatureScaleLbl.text = @"°F";
	}
}




@end
