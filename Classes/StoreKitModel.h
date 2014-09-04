//
//  StoreKitModel.h
//  SpeakAlarm
//
//  Created by Mark Davies on 10/20/11.
//  Copyright (c) 2011 Comantis LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "StoreKitControllerDelegate.h"
#import "StoreKitController.h"

@interface StoreKitModel : NSObject <SKProductsRequestDelegate>
{
NSMutableDictionary *productsDict;
    StoreKitController *skController;
    NSString * productSubscribeID;
    NSString * productVoicesID;
    NSString * productMessagesID;
}

@property (nonatomic, strong) NSDictionary *productsDict;
@property (nonatomic, strong) NSString *productSubscribeID;
@property (nonatomic, strong) NSString *productVoicesID;
@property (nonatomic, strong) NSString *productMessagesID;
@property (nonatomic, strong) StoreKitController *skController;

+ (id)sharedManager;
- (void) getProducts;
-(void)removeStoreKitController;
-(SKProduct*)getProductWithProductID:(NSString *)productID;
- (NSString *) priceAsStringForProductID:(NSString *)productID;

@end
