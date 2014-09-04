//
//  RSSFeedCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 9/21/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "RSSFeedCell.h"


@implementation RSSFeedCell
@synthesize nameLbl;
@synthesize linkLbl;
@synthesize enabledSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}





@end
