//
//  FriendsListCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 8/25/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FriendsListCell : UITableViewCell {
	IBOutlet UILabel* nameLbl;
	
	IBOutlet UIImageView* friendImage;
}

@property(nonatomic, strong) UILabel* nameLbl;
@property(nonatomic, strong) UIImageView* friendImage;


@end
