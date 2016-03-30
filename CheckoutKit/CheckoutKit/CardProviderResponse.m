//
//  CardProviderResponse.m
//  checkoutObjC
//
//  Created by Nicolas on 30/03/2016.
//  Copyright © 2016 checkout.com. All rights reserved.
//

#import "CardProviderResponse.h"

@implementation CardProviderResponse

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        NSArray *tempData = dictionary[@"data"];
        self.count = [dictionary[@"count"] intValue];
        
        self.data = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.count; i++)
        {
            CardProvider *cardProvider = [CardProvider alloc];
            [cardProvider setId:[[tempData objectAtIndex:i] valueForKey:@"id"]];
            [cardProvider setName:[[tempData objectAtIndex:i] valueForKey:@"name"]];
            [self.data addObject:cardProvider];
        }
    }
    return self;
}


@end
