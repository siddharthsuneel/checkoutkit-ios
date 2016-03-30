//
//  CheckoutKitObjC.h
//  checkoutObjC
//
//  Created by Nicolas on 22/03/2016.
//  Copyright © 2016 checkout.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "checkoutObjC-swift.h"
#import "CardTokenResponse.h"
#import "CardProviderResponse.h"

@interface CheckoutKitObjC : NSObject {
    NSString *publicKey;
    NSString *environment;
}

@property (nonatomic, retain) NSString *publicKey;
@property (nonatomic, retain) NSString *environment;


+ (id) checkoutKitInstance;

- (void)createCardToken:(Card*) card success : (void (^)(CardTokenResponse *responseDict))success failure:(void(^)(NSError* error))failure;

- (void)getCardProviders: (void (^)(CardProviderResponse *responseDict))success failure:(void(^)(NSError* error))failure;

@end
