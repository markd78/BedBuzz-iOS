//
//  GreetWithNameCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GreetWithNameCell : UITableViewCell {
	UISwitch *toggleSwitch;
}

@property (nonatomic,strong) IBOutlet UISwitch *toggleSwitch;
-(IBAction) switchValueChanged:(id)sender;


@end
