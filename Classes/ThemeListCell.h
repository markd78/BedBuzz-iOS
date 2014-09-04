//
//  ThemeListCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

@interface ThemeListCell : UITableViewCell {
	UILabel *titleLbl;
	UILabel *descriptionLbl;
	UIImageView *thumbnail;
	Theme *theme;
}

@property (nonatomic,strong) IBOutlet   UILabel *titleLbl;

@property (nonatomic,strong) IBOutlet   UILabel *descriptionLbl;

@property (nonatomic,strong) IBOutlet   UIImageView *thumbnail;


@property (nonatomic,strong)    Theme *theme;

@end
