//
//  ReviewCodeCell.h
//  SpeakAlarm
//
//  Created by Mark Davies on 5/18/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewCodeDelegate.h"

@interface ReviewCodeCell :  UITableViewCell <ReviewCodeDelegate, UITextFieldDelegate>
{
    UITextField *reviewCodeText;
    UIButton *submitBtn;
}

@property (nonatomic,strong) IBOutlet UITextField *reviewCodeText;
@property (nonatomic,strong) IBOutlet UIButton *submitBtn;

- (IBAction)submitBtnPressed:(id)sender;


@end
