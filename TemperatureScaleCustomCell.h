//
//  TemperatureScaleCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TemperatureScaleCustomCell : UITableViewCell {
	 UILabel *temperatureScaleLbl;
}


@property (nonatomic,strong) IBOutlet   UILabel *temperatureScaleLbl;

@end
