//
//  SelectFriendsForMessageViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/18/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendsForMessageViewController : UIViewController  <UITableViewDelegate,UITableViewDataSource>  {
	BOOL isBedBuzzFriendsMode; 
    BOOL isRecentlyUsedMode;
	IBOutlet UISegmentedControl* segmentedControl;
	IBOutlet UITableView* tableView;
    IBOutlet UIBarItem* composeBtn;
}

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
-(IBAction) segmentedControlIndexChanged;
-(IBAction)nextBtnClicked:(id)sender;
-(IBAction)cancel:(id)sender;
-(void)reloadFriendData;
-(void)popOverWasClosed;
-(void)addOrRemoveNextButton;

@end
