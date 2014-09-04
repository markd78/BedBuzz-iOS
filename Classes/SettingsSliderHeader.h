//
//  SettingsSliderHeader.h
//  SpeakAlarm
//
//  Created by Mark Davies on 11/30/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewHeaderDelegate.h"

@interface SettingsSliderHeader : UIView
{
id <TableViewHeaderDelegate> delegate;
}

- (id)initWithCallback:(id <TableViewHeaderDelegate>)delegateClass;
@property (strong, nonatomic) id <TableViewHeaderDelegate> delegate;
@end
