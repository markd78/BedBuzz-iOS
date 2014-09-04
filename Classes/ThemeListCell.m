//
//  ThemeListCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThemeListCell.h"


@implementation ThemeListCell
@synthesize titleLbl;
@synthesize descriptionLbl;
@synthesize thumbnail;
@synthesize theme;

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
