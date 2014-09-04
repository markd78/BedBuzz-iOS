//
//  StoreKitModel.m
//  SpeakAlarm
//
//  Created by Mark Davies on 10/20/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import "StoreKitModel.h"
#import "UserModel.h"
#import <StoreKit/StoreKit.h>
#import "PurchaseService.h"

static StoreKitModel *sharedMyManager = nil;

@implementation StoreKitModel
@synthesize productsDict;
@synthesize productMessagesID;
@synthesize productVoicesID;
@synthesize productSubscribeID;
@synthesize skController;

#pragma mark Singleton Methods
+ (id)sharedManager {
	@synchronized(self) {
		if(sharedMyManager == nil)
			sharedMyManager = [[super allocWithZone:NULL] init];
	}
	return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}
- (id)init {
	self = [super init];
	
	productsDict = [[NSMutableDictionary alloc] init];
    
    // create a new storekitcontroller, which will listen to events for restored purchases upon app start
    skController = [[StoreKitController alloc ] init];
    
	return self;
}

-(void)removeStoreKitController
{
    
    [ [SKPaymentQueue defaultQueue] removeTransactionObserver: skController];
}

-(void)setProductIDs
{
    if((void *)UI_USER_INTERFACE_IDIOM() != NULL &&
       UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        [self setProductSubscribeID:@"6MonthSubscriptionIPad"];
        [self setProductVoicesID:@"GreetingChangeIPad"];
        [self setProductMessagesID:@"5SendMessageCreditsIPad"];
    }
    else
    {
        [self setProductSubscribeID:@"6MonthSubscriptionIPhone"];
        [self setProductVoicesID:@"GreetingChange"];
        [self setProductMessagesID:@"5SendMessageCredits"];
    }
}

- (void) getProducts
{
    [self setProductIDs];
    
    NSSet *productIDs= [NSSet setWithObjects:productSubscribeID,productVoicesID,productMessagesID, nil];

	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productIDs ];
	request.delegate = self;
	[request start];
}

//***************************************
// PRAGMA_MARK: Delegate Methods
//***************************************
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSArray *myProduct = response.products;
	// populate UI
	for(int i=0;i<[myProduct count];i++)
	{
		SKProduct *product = [myProduct objectAtIndex:i];
		NSLog(@"Name: %@ - Price: %f",[product localizedTitle],[[product price] doubleValue]);
		NSLog(@"Product identifier: %@", [product productIdentifier]);
        
        [productsDict setObject:product forKey:product.productIdentifier];
	}
    
    NSLog(@"invalidProductIdentifiers: %@", response.invalidProductIdentifiers);
}

-(SKProduct*)getProductWithProductID:(NSString *)productID
{
    return [productsDict objectForKey:productID];
    
}

- (NSString *) priceAsStringForProductID:(NSString *)productID
{
    SKProduct *product = [self getProductWithProductID:productID];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[product priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[product price]];
    return str;
}

@end
