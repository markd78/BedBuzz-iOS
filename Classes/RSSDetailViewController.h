//
//  RSSDetailViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSFeed.h"
#import "FetchRSSDelegate.h"

@interface RSSDetailViewController : UIViewController <FetchRSSDelegate, UITableViewDelegate,UITableViewDataSource> {

	RSSFeed *rssFeed;
	IBOutlet UITextField* rssNameTextField;
	IBOutlet UITextField* rssLinkTextField;
	BOOL isNew;
	NSIndexPath *lastIndexPath;
	UITableView *voiceSettingsTableView;
    IBOutlet UIButton* testButton;
    IBOutlet UIButton* saveButton;
    IBOutlet UIActivityIndicatorView *spinner;
}


@property (nonatomic, strong) IBOutlet UITableView *voiceSettingsTableView;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRSSFeed:(RSSFeed *)rssFeed  isNew:(BOOL)isNewFeed;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)testRSSFeed;
- (IBAction)saveRSSFeed;

@property (nonatomic) BOOL isNew;
@property (nonatomic,strong)    RSSFeed *rssFeed;

@end
