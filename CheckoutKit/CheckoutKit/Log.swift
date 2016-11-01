//
//  Log.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 24/08/2015.
//
//

import Foundation

/** Class used to log activity in the console */

open class Log {
    fileprivate static let PATTERN_COMPACT_PRINT: String = "[\\n\\s]+"
    fileprivate static var log: Log? = nil
    
    /**
    Default constructor
    */
    fileprivate init() {}
    
    /**
    
    Function used for the Singleton Pattern, returns a unique Log instance

    */
    open class func getLog() -> Log {
        if (log == nil) {
            log = Log()
        }
        return log!
    }
    
    /**
    
    Prints an information message in the console and when it occurred
    
    @param message String containing the message to log
    
    */
    
    open func info(_ message: String) -> Void {
        printDate()
        let msg = Regex(pattern: Log.PATTERN_COMPACT_PRINT).replace(message, template: " ")
        print("INFO: \(msg)")
    }
    
    /**
    
    Prints a warning message in the console and when it occurred
    
    @param message String containing the message to log
    
    */
    
    open func warn(_ message: String) -> Void {
        printDate()
        let msg = Regex(pattern: Log.PATTERN_COMPACT_PRINT).replace(message, template: " ")
        print("WARNING: \(msg)")
    }
    
    /**
    
    Prints an error message in the console and when it occurred
    
    @param message String containing the message to log
    
    */
    
    open func error(_ message: String) -> Void {
        printDate()
        let msg = Regex(pattern: Log.PATTERN_COMPACT_PRINT).replace(message, template: " ")
        print("ERROR: \(msg)")
    }
    
    /*
    
    Private method used to print the current date in the console
    
    */
    
    fileprivate func printDate() -> Void {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        print(formatter.string(from: date))
    }
}
