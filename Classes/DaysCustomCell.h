//
//  DaysCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DaysCustomCell : UITableViewCell {
	UILabel *sundayLbl;
	UILabel *mondayLbl;
	UILabel *tuesdayLbl;
	UILabel *wednesdayLbl;
	UILabel *thursdaylbl;
	UILabel *fridayLbl;
	UILabel *saturdaylbl;
}

@property (nonatomic,strong) IBOutlet   UILabel *sundayLbl;
@property (nonatomic,strong) IBOutlet   UILabel *mondayLbl;
@property (nonatomic,strong) IBOutlet   UILabel *tuesdayLbl;
@property (nonatomic,strong) IBOutlet   UILabel *wednesdayLbl;
@property (nonatomic,strong) IBOutlet   UILabel *thursdayLbl;
@property (nonatomic,strong) IBOutlet   UILabel *fridayLbl;
@property (nonatomic,strong) IBOutlet   UILabel *saturdayLbl;


@end
