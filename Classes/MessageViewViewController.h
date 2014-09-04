//
//  MessageViewViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 6/6/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageVO.h"

@interface MessageViewViewController : UIViewController
{
IBOutlet UILabel* messageLbl;
IBOutlet UIImageView* userImage;
    MessageVO *messageShowing;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMessage:(MessageVO *)message;

@end

