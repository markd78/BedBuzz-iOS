//
//  AlarmMusicCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlarmMusicCustomCell : UITableViewCell {
	UILabel *artistLbl;
	 UILabel *trackName;
}

@property (nonatomic,strong) IBOutlet   UILabel *artistLbl;
@property (nonatomic,strong) IBOutlet   UILabel *trackNameLbl;

@end
