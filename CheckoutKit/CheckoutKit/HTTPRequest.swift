//
//  HTTPConnector.swift
//  test2
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Class used to manage the http connections with Checkout's server. Serves as an abstraction for get and post requests


public class HTTPRequest {
    
    /**
    
    Method allowing to send a GET request to a given url
    
    :param: url : String containing the url the request must be sent to
    
    :param: pk : String containing the public key of the merchant
    
    :param: debug : Bool if the logging is activated or not
    
    :param: log : Log instance with the logger it should log into
    
    :param: completion : Handler having a Response instance as a parameter
    
    */
    
    public class func getRequest<T: Serializable>(url: String, pk: String, debug: Bool, logger: Log, completion: (resp: Response<T>) -> Void) {
        var httpConn = getHTTPConnector(debug, logger: logger, completion: completion)
        httpConn.sendRequest(url, method: HTTPMethod.GET, payload: "", pk: pk)
    }
    
    /**
    
    Method allowing to send a POST request to a given url with a payload
    
    :param: url : String containing the url the request must be sent to
    
    :param: payload : String containing the data to be sent with the request
    
    :param: pk : String containing the public key of the merchant
    
    :param: debug : Bool if the logging is activated or not
    
    :param: log : Log instance with the logger it should log into
    
    :param: completion : Handler having a Response instance as a parameter
    
    */
    
    public class func postRequest<T: Serializable>(url: String, payload: String, pk: String, debug: Bool, logger: Log, completion: (resp: Response<T>) -> Void) {
            var httpConn = getHTTPConnector(debug, logger: logger, completion: completion)
            httpConn.sendRequest(url, method: HTTPMethod.POST, payload: payload, pk: pk)
    }
    
    /*
    Utility function used by getRequest and postRequest handling the JSON responses
    */
    private class func getHTTPConnector<T: Serializable>(debug: Bool, logger: Log, completion: (resp: Response<T>) -> Void) -> HTTPConnector {
        var httpConn = HTTPConnector(handler:{ (data: NSData, status: Int) -> Void in
            
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject]
            if jsonResult == nil {
                logger.error("** JSON Parsing Error CardProviders** \(NSString(data: data, encoding:NSUTF8StringEncoding))")
            } else {
                var resp: Response<T>
                if status == 200 {
                    var model = T(data: jsonResult!)
                    if model == nil {
                        logger.error("** JSON Parsing Error CardProviders** \(NSString(data: data, encoding:NSUTF8StringEncoding))")
                    } else {
                        resp = Response<T>(model: model!, status: status)
                        
                        if(debug){
                            logger.info("** HttpResponse**  Status 200 OK :\(jsonResult!.description)")
                        }
                        completion(resp: resp)
                    }
                } else {
                    var e = ResponseError<T>(data: jsonResult!)
                    if e == nil {
                        logger.error("** JSON Parsing Error CardProviders** \(NSString(data: data, encoding:NSUTF8StringEncoding))")
                    }
                    resp = Response<T>(error: e!, status: status)
                    if(debug){
                        logger.info("** HttpResponse**  StatusError: \(status) \(jsonResult!.description)");
                    }
                    completion(resp: resp)
                }
            }
            
            }, debug: debug, log: logger)
        return httpConn
    }
}

/// Class used to abstract the HTTP connection details

class HTTPConnector: NSObject {
    
    var httpStatus: Int = -1
    var handler: (data: NSData, status: Int) -> Void
    var log: Log
    var debug: Bool
    
    /**
    
    Default constructor
    
    :param: handler: handler having NSData (with the content of the response) and status (Int containing the HTTP status of the request) as parameters
    
    :param: debug : Bool if the logging is activated or not
    
    :param: log : Log instance with the logger it should log into
    
    */
    init(handler: (data: NSData, status: Int) -> Void, debug: Bool, log: Log) {
        self.handler = handler
        self.debug = debug
        self.log = log
    }

    /**
    
    Redefinition due to the delegate of NSURLConnection, called when the response contains data
    
    */
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        handler(data: data, status: httpStatus)
        
    }
    
    /**
    
    Redefinition due to the delegate of NSURLConnection, called when the a response is received
    */
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        httpStatus = response.statusCode
    }
    
    /**
    
    Redefinition due to the delegate of NSURLConnection, called when the response is finished loading
    
    */
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
    }
    
    /**
    
    Redefinition due to the delegate of NSURLConnection, called when the request failed and we received an error back
    */
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        log.error(error.description)
    }
    
    /**
    
    Function that sends a request with a given method, payload (if needed) and the correct headers for the REST call
    
    */
    
    func sendRequest(url: String, method: HTTPMethod, payload: String, pk: String) {
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "\(method.rawValue)"
        
        request.addValue(pk, forHTTPHeaderField: "AUTHORIZATION")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = payload.dataUsingEncoding(NSUTF8StringEncoding)
        
        if(debug){
            log.info("**Request**   \(method): \(url)")
            log.info("**Payload**   \(payload)")
        }
        
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
}

/**
Enumeration containing the different supported types of HTTP requests
*/

enum HTTPMethod: String {
    case GET = "GET", POST = "POST"
}