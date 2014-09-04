//
//  BuyViewController.m
//  SpeakAlarm
//
//  Created by Mark Davies on 10/16/11.
//  Copyright 2011 Comantis LLC. All rights reserved.
//

#import "BuyViewController.h"
#import "StoreKitController.h"
#import "StoreKitModel.h"
#import "UserModel.h"
#import "Flurry.h"

@implementation BuyViewController
@synthesize singleProductDescription;
@synthesize singleProductTitle;
@synthesize singleProductPrice;
@synthesize purchaseSingleProductBtn;
@synthesize premiumSubscriptionCostLbl;
@synthesize purchasePremiumSubscriptionBtn;
@synthesize pleaseWaitView;
//@synthesize storeKitController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndProductID:(NSString *)productIdentifier{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        StoreKitModel *skModel = [StoreKitModel sharedManager];
        
        singlePurchaseProductID = productIdentifier;
        singlePurchaseProduct = [skModel getProductWithProductID:productIdentifier];
        premiumSubscriptionProduct = [skModel getProductWithProductID:skModel.productSubscribeID];
    }
    return self;
}

-(void)popOverWasClosed
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Flurry logEvent:@"buy view"];
    
    pleaseWaitView.hidden = YES;
    
    StoreKitModel *skModel = [StoreKitModel sharedManager];
    singleProductTitle.text = singlePurchaseProduct.localizedTitle;
    singleProductDescription.text = singlePurchaseProduct.localizedDescription;
    singleProductPrice.text = [skModel priceAsStringForProductID:[singlePurchaseProduct productIdentifier]];
    NSString *buyText = [NSString stringWithFormat:@"Buy Now: %@", [skModel priceAsStringForProductID:[singlePurchaseProduct productIdentifier]]];
    
    [purchaseSingleProductBtn setTitle:buyText forState:UIControlStateNormal];
    
    NSString *subscriptionText = [NSString stringWithFormat:@"Upgrade Now! %@ / 6 months", [skModel priceAsStringForProductID:[premiumSubscriptionProduct productIdentifier]]];
    premiumSubscriptionCostLbl.text = [NSString stringWithFormat:@"%@ (one time) for 6 months of usage", [skModel priceAsStringForProductID:[premiumSubscriptionProduct productIdentifier]]];
    [purchasePremiumSubscriptionBtn setTitle:subscriptionText forState:UIControlStateNormal];
    
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



-(IBAction)purchaseSingleProductClicked:(id)sender
{
    
    
    pleaseWaitView.hidden = NO;
   StoreKitModel *skModel = [StoreKitModel sharedManager];
    [skModel.skController makePurchaseForProductID:singlePurchaseProductID AndReturnTo:self];
    
    currentlyPurchasingProductID = singlePurchaseProductID;
    
    NSString *purchaseEvent = [@"USER_PURCHASE_" stringByAppendingString:currentlyPurchasingProductID];
    [Flurry logEvent:purchaseEvent];
    
}
-(IBAction)purchasePremiumSubscriptionClicked:(id)sender
{
    
    StoreKitModel *skModel = [StoreKitModel sharedManager];
    
    pleaseWaitView.hidden = NO;

    [skModel.skController makePurchaseForProductID:skModel.productSubscribeID  AndReturnTo:self];
    
    currentlyPurchasingProductID = skModel.productSubscribeID;
    
     NSString *purchaseEvent = [@"USER_PURCHASE_" stringByAppendingString:currentlyPurchasingProductID];
    [Flurry logEvent:purchaseEvent];
}

-(void)paymentVerified
{
    pleaseWaitView.hidden = YES;
    
    // dismiss the buy page
    [self.navigationController popViewControllerAnimated: YES];
    
    
}



-(void)paymentError:(NSString *)paymentErrorStr
{
    
    pleaseWaitView.hidden = YES;
    
}

@end
