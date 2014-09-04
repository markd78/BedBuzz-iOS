//
//  RSSFeedCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RSSFeedCell : UITableViewCell {
	IBOutlet UILabel* nameLbl;
	IBOutlet UILabel* linkLbl;
    IBOutlet UISwitch* enabledSwitch;
}

@property(nonatomic, strong) UILabel* nameLbl;
@property(nonatomic, strong) UILabel* linkLbl;
@property(nonatomic, strong) UISwitch* enabledSwitch;

@end
