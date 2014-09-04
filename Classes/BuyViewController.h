//
//  BuyViewController.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/16/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "StoreKitControllerDelegate.h"
#import "StoreKitController.h"

@interface BuyViewController : UIViewController <StoreKitControllerDelegate> {
    NSString* singlePurchaseProductID;
    SKProduct* singlePurchaseProduct;
    SKProduct* premiumSubscriptionProduct;
    
    UILabel* singleProductTitle;
    UILabel* singleProductPrice;
    UITextView* singleProductDescription;
    UIButton* purchaseSingleProductBtn;
    UILabel*  premiumSubscriptionCostLbl;
    UIButton* purchasePremiumSubscriptionBtn;
    //StoreKitController* storeKitController;
    UIView* pleaseWaitView;
    
    NSString* currentlyPurchasingProductID;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndProductID:(NSString *)productIdentifier;
@property (nonatomic, strong) IBOutlet UITextView *singleProductDescription;
@property (nonatomic, strong) IBOutlet UILabel *singleProductTitle;
@property (nonatomic, strong) IBOutlet UILabel *singleProductPrice;
@property (nonatomic, strong) IBOutlet UILabel *premiumSubscriptionCostLbl;
@property (nonatomic, strong) IBOutlet UIButton *purchaseSingleProductBtn;
@property (nonatomic, strong) IBOutlet UIButton *purchasePremiumSubscriptionBtn;
@property (nonatomic, strong) IBOutlet UIView *pleaseWaitView;
//@property (nonatomic, retain) StoreKitController *storeKitController;

-(IBAction)purchaseSingleProductClicked:(id)sender;
-(IBAction)purchasePremiumSubscriptionClicked:(id)sender;
-(void)paymentVerified;
-(void)paymentError:(NSString *)paymentErrorStr;
-(void)popOverWasClosed;
@end
