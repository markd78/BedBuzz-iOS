//
//  ReviewCodeCell.m
//  SpeakAlarm
//
//  Created by Mark Davies on 5/18/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "ReviewCodeCell.h"
#import "ReviewCodeService.h"
#import "UserModel.h"
#import "iToast.h"
#import "SoundDirector.h"

@implementation ReviewCodeCell
@synthesize submitBtn;
@synthesize reviewCodeText;

- (IBAction)submitBtnPressed:(id)sender
{
    UserModel *um = [UserModel userModel];
    ReviewCodeService *reviewCodeService = [[ReviewCodeService alloc] init];
	[reviewCodeService submitReviewCode:um.userSettings.bedBuzzID andReviewCode:reviewCodeText.text AndReturnTo:self];

    if (reviewCodeText!=nil)
    {
        [reviewCodeText resignFirstResponder];
    }
}

-(void)reviewCodeResult:(BOOL)result
{
    if (result == NO)
    {
        [[[[iToast makeText:NSLocalizedString(@"This review code is either invalid, or has already been used", @"")] 
           setGravity:iToastGravityBottom] setDuration:1000] show];

    }
    else {
        [[[[iToast makeText:NSLocalizedString(@"Thanks for taking the time to review this app!", @"")] 
           setGravity:iToastGravityBottom] setDuration:1000] show];
        
        UserModel *um = [UserModel userModel];
        um.userSettings.isPaidUser = YES;
        [um saveUserSettings];
        
        SoundDirector *sd = [SoundDirector soundDirector];
        [sd sayThanksForReview];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length > 0)
    {
        submitBtn.enabled = YES;
    }
    else
    {
        submitBtn.enabled = NO;
    }
    
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
	
    [sender resignFirstResponder];
}


@end
