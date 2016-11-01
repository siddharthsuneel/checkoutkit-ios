//
//  HTTPConnector.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation

/** Class used to manage the http connections with Checkout's server. Serves as an abstraction for get and post requests */


open class HTTPRequest {
    
    /**
    
    Method allowing to send a GET request to a given url
    
    @param url String containing the url the request must be sent to
    
    @param pk String containing the public key of the merchant
    
    @param debug Bool if the logging is activated or not
    
    @param log Log instance with the logger it should log into
    
    @param completion Handler having a Response instance as a parameter
    
    */
    
    open class func getRequest<T: Serializable>(_ url: String, pk: String, debug: Bool, logger: Log, completion: @escaping (_ resp: Response<T>) -> Void) {
        let httpConn = getHTTPConnector(debug, logger: logger, completion: completion)
        httpConn.sendRequest(url, method: HTTPMethod.GET, payload: "", pk: pk)
    }
    
    /**
    
    Method allowing to send a POST request to a given url with a payload
    
    @param url String containing the url the request must be sent to
    
    @param payload String containing the data to be sent with the request
    
    @param pk String containing the public key of the merchant
    
    @param debug Bool if the logging is activated or not
    
    @param log Log instance with the logger it should log into
    
    @param completion Handler having a Response instance as a parameter
    
    */
    
    open class func postRequest<T: Serializable>(_ url: String, payload: String, pk: String, debug: Bool, logger: Log, completion: @escaping (_ resp: Response<T>) -> Void) {
            let httpConn = getHTTPConnector(debug, logger: logger, completion: completion)
            httpConn.sendRequest(url, method: HTTPMethod.POST, payload: payload, pk: pk)
    }
    
    /*
    Utility function used by getRequest and postRequest handling the JSON responses
    */
    fileprivate class func getHTTPConnector<T: Serializable>(_ debug: Bool, logger: Log, completion: @escaping (_ resp: Response<T>) -> Void) -> HTTPConnector {
        let httpConn = HTTPConnector(handler:{ (data: Data, status: Int, error: Bool) -> Void in
            if (error) {
                completion(Response<T>(error: nil, status: -1))
            } else {
            let jsonResult = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: AnyObject]
            if jsonResult == nil {
                logger.error("** JSON Parsing Error CardProviders** \(NSString(data: data, encoding:String.Encoding.utf8.rawValue))")
            } else {
                var resp: Response<T>
                if status == 200 {
                    let model = T(data: jsonResult!)
                    if model == nil {
                        logger.error("** JSON Parsing Error CardProviders** \(NSString(data: data, encoding:String.Encoding.utf8.rawValue))")
                    } else {
                        resp = Response<T>(model: model!, status: status)
                        
                        if(debug){
                            logger.info("** HttpResponse**  Status 200 OK \(jsonResult!.description)")
                        }
                        completion(resp)
                    }
                } else {
                    let e = ResponseError<T>(data: jsonResult!)
                    if e == nil {
                        logger.error("** JSON Parsing Error CardProviders** \(NSString(data: data, encoding:String.Encoding.utf8.rawValue))")
                        return
                    }
                    resp = Response<T>(error: e!, status: status)
                    if(debug){
                        logger.info("** HttpResponse**  StatusError: \(status) \(jsonResult!.description)");
                    }
                    completion(resp)
                }
            }
            }
            
            }, debug: debug, log: logger)
        return httpConn
    }
}

/// Class used to abstract the HTTP connection details

class HTTPConnector {
    
    var httpStatus: Int = -1
    var handler: (_ data: Data, _ status: Int, _ error: Bool) -> Void
    var log: Log
    var debug: Bool
    
    /**
    
    Default constructor
    
    @param handler: handler having NSData (with the content of the response) status (Int containing the HTTP status of the request) and a Boolean error (true if there is a problem with the response) as parameters
    
    @param debug Bool if the logging is activated or not
    
    @param log Log instance with the logger it should log into
    
    */
    init(handler: @escaping (_ data: Data, _ status: Int, _ error: Bool) -> Void, debug: Bool, log: Log) {
        self.handler = handler
        self.debug = debug
        self.log = log
    }
    
    /**
    
    Function that sends a request with a given method, payload (if needed) and the correct headers for the REST call
    
    */
    
    func sendRequest(_ url: String, method: HTTPMethod, payload: String, pk: String) {
        let request: NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: url)
        request.httpMethod = "\(method.rawValue)"
        
        request.addValue(pk, forHTTPHeaderField: "AUTHORIZATION")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = payload.data(using: String.Encoding.utf8)
        
        if(debug){
            log.info("**Request**   \(method): \(url)")
            log.info("**Payload**   \(payload)")
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if error != nil {
                self.handler(Data(), -1, true)
                self.log.error(error!.localizedDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                self.handler(data!, httpResponse!.statusCode, false)
            }
        }
        task.resume()
    }
}

/**
Enumeration containing the different supported types of HTTP requests
*/

enum HTTPMethod: String {
    case GET = "GET", POST = "POST"
}
