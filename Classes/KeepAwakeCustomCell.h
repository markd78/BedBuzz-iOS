//
//  KeepAwakeCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 12/2/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeepAwakeCustomCell : UITableViewCell
{
UISwitch *toggleSwitch;
}

@property (nonatomic,strong) IBOutlet UISwitch *toggleSwitch;
-(IBAction) switchValueChanged:(id)sender;


@end
