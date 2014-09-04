//
//  AlarmCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 12/2/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmCustomCell : UITableViewCell
{
UILabel *nameLbl;
UILabel *timeLbl;
UILabel *daysLbl;
}

@property (nonatomic,strong) IBOutlet UILabel *nameLbl;
@property (nonatomic,strong) IBOutlet UILabel *timeLbl;
@property (nonatomic,strong) IBOutlet UILabel *daysLbl;
@end
