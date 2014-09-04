//
//  PurchaseService.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/27/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentServiceDelegate.h"
#import "PurchaseService.h"
#import "Utilities.h"
#import <StoreKit/StoreKit.h>

@interface PurchaseService : NSObject <NSURLConnectionDelegate>
{
    id <PaymentServiceDelegate> delegate;
    SKPaymentTransaction *transactionChecking;
     NSMutableData *_responseData;
}

-(void)verifyReceiptForUser:(NSNumber *)bedBuzzID withReceiptData:(NSString *)receiptData  forTransaction:(SKPaymentTransaction *)transaction  AndReturnTo:(id <PaymentServiceDelegate>)delegateClass;
-(void) paymentVerified;
-(void) paymentError:(NSString *)paymentErrorStr;

@property (strong, nonatomic) id <PaymentServiceDelegate> delegate;
@property (strong, nonatomic) SKPaymentTransaction *transactionChecking;
@end
