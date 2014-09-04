//
//  DaysCustomCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DaysCustomCell.h"


@implementation DaysCustomCell
@synthesize sundayLbl;
@synthesize mondayLbl;
@synthesize tuesdayLbl;
@synthesize wednesdayLbl;
@synthesize thursdayLbl;
@synthesize fridayLbl;
@synthesize saturdayLbl;


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
