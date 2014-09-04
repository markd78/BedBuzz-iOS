//
//  AlarmDetailTableController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alarm.h"

@interface AlarmDetailTableController : UITableViewController <MPMediaPickerControllerDelegate, UIAlertViewDelegate> {
	IBOutlet UITableView* alarmDetailTableView;
    UIPopoverController *popOverController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil alarm:(Alarm *)alarm;
- (IBAction)dismissKeyboard:(id)sender;
- (void) selectSong;
-(void)selectSongOnIPad;
-(void)deletePressed;

@property (nonatomic, strong) UIPopoverController *popOverController; 
@end
