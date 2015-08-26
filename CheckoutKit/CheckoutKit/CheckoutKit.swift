//
//  CheckoutKit.swift
//  test2
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation

/// Main class allowing to create one CheckoutKit instance, provide the merchant's public key and create card tokens

public class CheckoutKit {
    
    public let PUBLIC_KEY_REGEX_VALIDATION: String = "^pk_(?:test_)?(?:\\w{8})-(?:\\w{4})-(?:\\w{4})-(?:\\w{4})-(?:\\w{12})$"
    
    private static var ck: CheckoutKit? = nil
    
    var pk: String!
    var env: Environment
    var logging: Bool
    var logger: Log
    
    /*
    
    Enumeration containing the basic definition of the avaiable REST functions
    
    */
    
    enum RESTFunction: String {
        case GETCARDPROVIDERS = "providers/cards"
        case CREATECARDTOKEN = "tokens/card"
    }
    
    /*
    
    Private constructor used for the Singleton Pattern
    
    :param: pk : String containing the merchant's public key
    
    :param: env   : Environment object containing the information of the merchant's environment, default is SANDBOX
    
    :param: logging   : boolean, if the debug mode is activated or not, default is true
    
    :param: logger    : Log instance for logging purposes if debug mode is activated
    
    :param: error : NSErrorPointer : if an error occurs or the public key is invalid, the error object is defined accordingly
    
    */
    
    private init?(pk: String, env: Environment, logging: Bool, logger: Log, error: NSErrorPointer) {
        self.env = env
        self.logging = logging
        self.logger = logger

        if !Regex(pattern: PUBLIC_KEY_REGEX_VALIDATION).matches(pk) && error != nil {
            error.memory = NSError(domain: CheckoutError.InvalidPK.rawValue, code: -1, userInfo:nil)
            logger.info("**Wrong public key**   \(pk)")
            return nil
        }
        self.pk = pk
        if(self.logging){
            self.logger.info("**CheckoutKit created**   \(pk)")
        }
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    :param: pk : String containing the merchant's public key
    
    :param: env   : Environment object containing the information of the merchant's environment, default is SANDBOX
    
    :param: logging   : boolean, if the debug mode is activated or not, default is true
    
    :param: logger    : Log instance for logging purposes if debug mode is activated
    
    :param: error : NSErrorPointer : if an error occurs or the public key is invalid, the error object is defined accordingly
    
    */
    
    public class func getInstance(pk: String, env: Environment, logging: Bool, logger: Log, error: NSErrorPointer) -> CheckoutKit? {
        if (ck == nil) {
            ck = CheckoutKit(pk: pk, env: env, logging: logging, logger: logger, error: error)
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    :param: pk : String containing the merchant's public key
    
    :param: error : NSErrorPointer : if an error occurs or the public key is invalid, the error object is defined accordingly
    
    */
    
    public class func getInstance(pk: String, error: NSErrorPointer) -> CheckoutKit? {
        if (ck == nil) {
            ck = CheckoutKit(pk: pk, env: Environment.SANDBOX, logging: true, logger: Log.getLog(), error: error)
        }
        return ck
    }
    
    public class func getInstance(error: NSErrorPointer) -> CheckoutKit? {
        if (ck == nil && error != nil) {
            error.memory = NSError(domain: CheckoutError.NoPK.rawValue, code: -1, userInfo:nil)
            return nil
        }
        return ck
    }
    
    /*
    
    Private function used for generating the correct url for REST calls
    
    :param: function : RESTFunction instance containing the details of the REST fonction to be called
    
    */
    
    private func getUrl(function: RESTFunction) -> String {
        return "\(self.env.rawValue)\(function.rawValue)"
    }
    
    /**
    
    Function that calls getCardProviders via REST on the server specified in Environment
    
    :param: completion : Handler having a instance of Response<CardProviderResponse> as a parameter
    
    :returns: CardProvider array containing the Checkout card providers
    
    */
    
    public func getCardProviders(completion: Response<CardProviderResponse> -> Void) {
        if(logging){
            logger.info("**GetCardProviders called**   \(pk)")
        }
        HTTPRequest.getRequest(getUrl(RESTFunction.GETCARDPROVIDERS), pk: self.pk, debug: self.logging, logger: self.logger, completion:{ (resp: Response<CardProviderResponse>) -> Void in
            completion(resp)
        })
    }
    
    /**
    
    Function that calls createCardToken via REST on the server specified in Environment
    
    :param: card : Card object containing the informations to be tokenized
    
    :param: completion : Handler having a instance of Response<CardTokenResponse> as a parameter
    
    :returns: CardToken object containing all the information received by the server

    */
    
    public func createCardToken(card: Card, completion: Response<CardTokenResponse> -> Void) {
        if(logging){
            logger.info("**CreateCardToken called**   \(pk)")
        }
        var data: String = ""
        if NSJSONSerialization.isValidJSONObject(card.getJson()) {
            let c = NSJSONSerialization.dataWithJSONObject(card.getJson(), options: nil, error: nil)
            data = NSString(data: c!, encoding:NSUTF8StringEncoding)! as String
        }
        HTTPRequest.postRequest(getUrl(RESTFunction.CREATECARDTOKEN), payload: data, pk: self.pk, debug: self.logging, logger: self.logger, completion:{ (resp: Response<CardTokenResponse>) -> Void in
            completion(resp)
        })
        
    }
    
    public class func destroy() {
        ck = nil
    }
}

/*

Enumeration containing the different environments for generating the tokens, it contains the URL corresponding to the environment

*/

public enum Environment: String {
    case LIVE = "https://api2.checkout.com/v2/"
    case SANDBOX = "https://sandbox.checkout.com/api2/v2/"
}