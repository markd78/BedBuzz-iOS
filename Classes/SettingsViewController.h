//
//  SettingsViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceSettingsViewController.h"
#import "ThemeListTableViewController.h"
#import "TableViewHeaderDelegate.h"

@interface SettingsViewController : UITableViewController <TableViewHeaderDelegate> {
	IBOutlet UITableView* alarmSettingsTableView;
	VoiceSettingsViewController* voiceSettingsViewController;
}
@property (nonatomic, strong) VoiceSettingsViewController *voiceSettingsViewController;
@property (nonatomic, strong) ThemeListTableViewController *themesTableViewController;

-(void)popOverWasClosed;

@end
