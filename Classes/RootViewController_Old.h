//
//  RootViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 11/13/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController_Old : UIViewController
{
    IBOutlet UILabel* loggingOnLbl;
    IBOutlet UIActivityIndicatorView* spinner;
    IBOutlet UIImageView* imageView;
    BOOL isFromAlarm;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil fromAlarmNotification:(BOOL)fromAlarm;

@end
