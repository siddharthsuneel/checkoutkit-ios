//
//  CardProviderResponse.h
//  checkoutObjC
//
//  Created by Nicolas on 30/03/2016.
//  Copyright © 2016 checkout.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "checkoutObjC-swift.h"

@interface CardProviderResponse : NSObject

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, assign) int count;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
