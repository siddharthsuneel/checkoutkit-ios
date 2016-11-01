//
//  Card.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation

/** Class containing the card's details before sending them to createCardToken */

@objc open class Card: NSObject {
    var name: String?
    var number: String!
    var expYear: String!
    var expMonth: String!
    var cvv: String!
    var billingDetails: CustomerDetails?
    
    /**
    
    Default constructor
    
    @param number String containing the card's number
    
    @param name String containing the card's owner name
    
    @param expMonth String containing the expiry month
    
    @param expYear String containing the expiry year
    
    @param cvv String containing the CVV
    
    @param billingDetails CustomerDetails object containing the information of the customer, optional
    
    @throws CardError if an error occurs or one of the values is invalid
    
    */
        
    
@objc open func verify() -> Bool{
    
    var cardValid = true
    
    if !CardValidator.validateCardNumber(self.number) {
        print(CardError.invalidNumber)
        cardValid = false
    }
    
    let c = CardValidator.getCardType(self.number)
    if (c == nil || !CardValidator.validateCVV(cvv, card: c!)) {
        print(CardError.invalidCVV)
        cardValid = false
    }
    
    if !CardValidator.validateExpiryDate(self.expMonth, year: self.expYear) {
        print(CardError.invalidExpiryDate)
        cardValid = false
    }
    
    return cardValid
    
}
    
    /**
    
    Function returning the JSON representation of this Card instance
    
    @return Dictionary [String: AnyObject] containing the JSON components of the instance
    
    */
    func getJson() -> [String: AnyObject] {
        var dic: [String: AnyObject] = [
                "number": number as AnyObject,
                "expiryYear": expYear as AnyObject,
                "expiryMonth": expMonth as AnyObject,
                "cvv": cvv as AnyObject
            ]
        if !(self.billingDetails == nil) {
            dic["billingDetails"] = self.billingDetails!.getJson() as AnyObject?
        }
        if !(self.name == nil) {
            dic["name"] = self.name! as AnyObject?
        }
        return dic
    }

}
