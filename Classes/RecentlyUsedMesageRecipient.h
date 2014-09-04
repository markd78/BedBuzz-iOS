//
//  RecentlyUsedMesageReceipient.h
//  SpeakAlarm
//
//  Created by Mark Davies on 11/4/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentlyUsedMesageRecipient: NSObject <NSCoding>
{
    NSNumber *fbID;
    NSDate *dateUsed;
}

@property (nonatomic, strong)  NSNumber *fbID;
@property (nonatomic, strong)  NSDate *dateUsed;

@end
