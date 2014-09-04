//
//  EnabledCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EnabledCustomCell : UITableViewCell {
	UISwitch *toggleSwitch;

}

@property (nonatomic,strong) IBOutlet UISwitch *toggleSwitch;
-(IBAction) switchValueChanged:(id)sender;


@end
