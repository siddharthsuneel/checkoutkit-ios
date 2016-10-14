//
//  CardProviderResponse.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation

/** Class used for receiving REST messages, it has the same format as the expected response. We extract the useful information based on this. */

open class CardProviderResponse: Serializable {
    open var object: String!
    open var count: Int!
    open var data: [CardProvider]!
    
    /**
    
    Convenience constructor
    
    @param data Dictionary [String: AnyObject] containing a JSON representation of a CardProviderResponse instance
    
    */
    
    public required init?(data: [String: AnyObject]) {
        if let i = data["data"] as? [[String: AnyObject]], let count = data["count"] as? Int, let obj = data["object"] as? String {
            var cps: [CardProvider] = []
            for cp in i {
                let c = CardProvider(data: cp)
                if c == nil {
                    return nil
                } else {
                    cps.append(c!)
                }
            }
            self.count = count
            self.object = obj
            self.data = cps
        } else {
            return nil
        }
    }
    
    
    /**
    
    Default constructor
    
    @param object String containing type of the JSON data
    
    @param count int containing the number of elements in the JSON data
    
    @param data String containing the JSON data
    
    */
    public init(count: Int, object: String, data: [CardProvider]) {
        self.count = count
        self.data = data
        self.object = object
    }
}
