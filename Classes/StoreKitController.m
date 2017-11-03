//
//  StoreKitController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 10/27/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "StoreKitController.h"
#import "StoreKitControllerDelegate.h"
#import "UserModel.h"
#import <StoreKit/StoreKit.h>
#import "PurchaseService.h"
#import "StoreKitModel.h"
#import "NonRenewSubscriptionService.h"

@implementation StoreKitController
@synthesize storeKitControllerDelegate;
@synthesize transactionBeingProcessed;



- (id)init {
	self = [super init];
    
    [ [SKPaymentQueue defaultQueue] addTransactionObserver: self];
    
    return self;
}

-(void)removeTransactionObserver
{
    [ [SKPaymentQueue defaultQueue] removeTransactionObserver: self];
 }

-(void)makePurchaseForProductID:(SKProduct *)product  AndReturnTo:(id <StoreKitControllerDelegate>)delegateClass
{
     self.storeKitControllerDelegate = delegateClass;
    
    
    
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue
removedTransactions:(NSArray *)transactions
{
    
}

-(void) AlertWithMessage:(NSString *)message
{
    /* open an alert with an OK button */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"BedBuzz" 
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles: nil];
    [alert show];
}

-(void)completedPurchaseTransaction:(SKPaymentTransaction *)transaction 
{
    self.transactionBeingProcessed = transaction;
    
    StoreKitModel *skModel = [StoreKitModel sharedManager];
    
    // PERFORM THE SUCCESS ACTION
    if ([transaction.payment.productIdentifier isEqualToString:skModel.productVoicesID]) {
        
        UserModel *userModel = [UserModel userModel];
        userModel.userSettings.changeVoiceNameCredits = userModel.userSettings.changeVoiceNameCredits+1;
        [userModel saveUserSettings];
        
        // Finish Transaction
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self AlertWithMessage:@"Thank you for your purchase."];
        
        
        [storeKitControllerDelegate paymentVerified];
        
    }
    else if ([transaction.payment.productIdentifier isEqualToString:skModel.productMessagesID]) {
        UserModel *userModel = [UserModel userModel];
        userModel.userSettings.sendMessageCredits = userModel.userSettings.sendMessageCredits+5;
        [userModel saveUserSettings];
        
        // Finish Transaction
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self AlertWithMessage:@"Thank you for your purchase"];
        
        
        [storeKitControllerDelegate paymentVerified];
    }
    else if ([transaction.payment.productIdentifier isEqualToString:skModel.productSubscribeID]) 
    {
        UserModel *userModel = [UserModel userModel];
        
       /* NSString *receiptStringEncoded = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];      
        
        // verify & save the receipt on the server
        PurchaseService *paymentService = [[PurchaseService alloc] init];
        [paymentService verifyReceiptForUser:userModel.userSettings.bedBuzzID withReceiptData:receiptStringEncoded forTransaction:transaction AndReturnTo:self];*/
        
        NonRenewSubscriptionService *service = [[NonRenewSubscriptionService alloc] init];
        [service   subscribeUser:userModel.userSettings.bedBuzzID ForThisManyMonths:[NSNumber numberWithInt:6]];
        
        // Finish Transaction
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [self AlertWithMessage:@"Thank you for subscribing to unlimited BedBuzz!"];
        
         userModel.userSettings.isPaidUser = YES;
        
        [storeKitControllerDelegate paymentVerified];
        
       
    }
    
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}
/*
-(void)handleFailedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [self AlertWithMessage:@"Transaction error.  Please try again later."];
        
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
*/

- (void) handleFailedTransaction:(SKPaymentTransaction *) transaction
{
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSMutableString *messageToBeShown = [[NSMutableString alloc] init];
        
        if ([transaction.error localizedFailureReason] != nil) {
            [messageToBeShown setString:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Reason:", @"Reason Text in alert when payment transaction failed"), [transaction.error localizedFailureReason]]];
            
            if ([transaction.error localizedRecoverySuggestion] != nil)
                [messageToBeShown appendFormat:@", %@ %@", NSLocalizedString(@"You can try:", @"Text for sugesstion in alert when payment transaction failed"), [transaction.error localizedRecoverySuggestion]];
        }
        
         [self AlertWithMessage:messageToBeShown];
        
        
    }
    
}


-(void)repurchase
{
    // Repurchase an already purchased item (for non-consumables)
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored:
                [self completedPurchaseTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self handleFailedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                //[self repurchase];
                break;
            default:
                break;
        }
    }
}

-(void)paymentVerifiedForTransaction:(SKPaymentTransaction *)transaction
{
 //   [self AlertWithMessage:@"Thank you for subscribing to premium Bed-Buzz!"];
    
    if (transaction.payment.productIdentifier)
    {
        UserModel *userModel = [UserModel userModel];
        userModel.userSettings.isPaidUser = YES; 
    }
    
    // Finish Transaction
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    [storeKitControllerDelegate paymentVerified];
}

-(void)paymentError:(NSString *)paymentErrorStr ForTransaction:(SKPaymentTransaction *)transaction
{
    [self AlertWithMessage:@"There was an error making the payment"];
    
    // Finish Transaction
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
  
    
    [storeKitControllerDelegate paymentError:paymentErrorStr];
}


@end
