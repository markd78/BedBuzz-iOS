//
//  PaymentServiceDelegate.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/27/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol PaymentServiceDelegate <NSObject>
-(void)paymentVerifiedForTransaction:(SKPaymentTransaction *)transactionChecking;
-(void)paymentError:(NSString *)paymentErrorStr ForTransaction:(SKPaymentTransaction *)transactionChecking;

@end
