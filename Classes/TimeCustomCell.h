//
//  TimeCustomCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeCustomCell : UITableViewCell {
	 UILabel *timeLbl;
}

-(NSString *)getTimeString ;
@property (nonatomic,strong) IBOutlet   UILabel *timeLbl;

@end
