//
//  MessageViewViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 6/6/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import "MessageViewViewController.h"
#import "MessageVO.h"
#import "FacebookModel.h"
#import "FacebookUser.h"

@implementation MessageViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMessage:(MessageVO *)message
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        messageShowing = message;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FacebookModel *fm = [FacebookModel sharedManager];
    
	// Do any additional setup after loading the view.
    [messageLbl setText:messageShowing.messageText];
    
    // add the image
   FacebookUser *sender =  [fm.friendsDict objectForKey:messageShowing.senderID];
    NSURL * imageURL = [NSURL URLWithString:sender.picSmallURL];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *friendImage = [[UIImage alloc] initWithData:imageData]; 
    [userImage setImage:friendImage];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
