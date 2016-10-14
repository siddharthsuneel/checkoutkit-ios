//
//  Response.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation

/** Class used to modelise a Response from the server, containing the actual data returned, in model and all the information related to the response*/

open class Response<T: Serializable> {
    open var hasError: Bool
    open var httpStatus: Int
    open var error: ResponseError<T>?
    open var model: T?
    
    /**

    Default constructor
    
    @param model T instance containing the response content of the request
    
    @param status Int containing the HTTP status of the response
    
    */
    public init(model: T, status: Int) {
        self.hasError = false
        self.model = model
        self.error = nil
        self.httpStatus = status
    }
    
    /**
    
    Constructor used in case of error
    
    @param error ResponseError instance containing the details of the error
    
    @param status Int containing the HTTP status of the response
    
    */
    
    public init(error: ResponseError<T>?, status: Int) {
        self.hasError = true
        self.model = nil
        self.error = error
        self.httpStatus = status
    }
}
