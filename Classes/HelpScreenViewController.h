//
//  HelpScreenViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 2/9/12.
//  Copyright (c) 2012 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpScreenDelegate.h"

@interface HelpScreenViewController : UIViewController
{
    id <HelpScreenDelegate> delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andReturnTo:(id <HelpScreenDelegate>)delegateClass;
@property (strong, nonatomic) id <HelpScreenDelegate> delegate;
@end
