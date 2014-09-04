//
//  RSSFeedsViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSSFeedsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	UITableView *rssFeedsTableView;
	IBOutlet UIButton* editButton;
}

@property (nonatomic, strong) IBOutlet UITableView *rssFeedsTableView;
- (IBAction)editBtnClicked:(id)sender;

@end
