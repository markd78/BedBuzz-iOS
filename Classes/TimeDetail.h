//
//  TimeDetail.h
//  SpeakAlarm
//
//  Created by Mark Davies on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimeDetail : UIViewController {
  UIDatePicker* timePicker;
}

@property (nonatomic,strong) IBOutlet  UIDatePicker* timePicker;
-(IBAction) timechanged;

@end
