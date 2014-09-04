//
//  StoreKitControllerDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/27/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StoreKitControllerDelegate <NSObject>

-(void)paymentVerified;
-(void)paymentError:(NSString *)paymentErrorStr;
@end
