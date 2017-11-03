//
//  StoreKitController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/27/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKitControllerDelegate.h"
#import "PaymentServiceDelegate.h"
#import <StoreKit/StoreKit.h>

@interface StoreKitController : NSObject <SKPaymentTransactionObserver, PaymentServiceDelegate>
{
    id <StoreKitControllerDelegate> storeKitControllerDelegate;
    SKPaymentTransaction *transactionBeingProcessed;
}


@property (strong, nonatomic) id <StoreKitControllerDelegate> storeKitControllerDelegate;
@property (strong, nonatomic) SKPaymentTransaction *transactionBeingProcessed;

-(void)makePurchaseForProductID:(SKProduct *)product AndReturnTo:(id <StoreKitControllerDelegate>)delegateClass;
-(void)completedPurchaseTransaction:(SKPaymentTransaction *)transaction  ;
- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length;
-(void)paymentVerifiedForTransaction:(SKPaymentTransaction *)transaction;
-(void)paymentError:(NSString *)paymentErrorStr ForTransaction:(SKPaymentTransaction *)transaction;
-(void)removeTransactionObserver;

@end

