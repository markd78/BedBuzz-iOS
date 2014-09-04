//
//  ShowFacebookBtnCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/8/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowStatusBarCell : UITableViewCell
{
    UISwitch *toggleSwitch;
}

@property (nonatomic,strong) IBOutlet UISwitch *toggleSwitch;
-(IBAction) switchValueChanged:(id)sender;


@end
