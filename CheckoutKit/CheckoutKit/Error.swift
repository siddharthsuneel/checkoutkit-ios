//
//  Error.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 20/08/2015.
//
//

import Foundation

/** Custom errors used for validation errors */

public enum CardError: Error {
    case invalidNumber
    case invalidCVV
    case invalidExpiryDate

    var desc: String
        {
            switch self
            {
            case .invalidNumber: return "Invalid card number"
            case .invalidCVV: return "Invalid CVV"
            case .invalidExpiryDate: return "Invalid expiry date"
            }
    }
}

public enum CheckoutError: Error {
    case invalidPK
    case noPK
    
    var desc: String
        {
            switch self
            {
            case .invalidPK: return "Invalid public key"
            case .noPK: return "No public key has been set"
            }
    }
}
