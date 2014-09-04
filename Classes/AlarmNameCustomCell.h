//
//  AlarmNameCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlarmNameCustomCell : UITableViewCell <UITextFieldDelegate> {
	IBOutlet UITextField* alarmNameTextField;
}


- (IBAction)dismissKeyboard:(id)sender;

@end
