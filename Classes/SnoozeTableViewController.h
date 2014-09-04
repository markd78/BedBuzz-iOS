//
//  SnoozeTableViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SnoozeTableViewController : UITableViewController {
	NSIndexPath *lastIndexPath;
}

@property (nonatomic,strong) NSIndexPath *lastIndexPath;

@end
