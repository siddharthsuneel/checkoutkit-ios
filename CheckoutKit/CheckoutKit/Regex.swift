//
//  Regex.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 19/08/2015.
//
//

import Foundation

/** Utility class used to abstract the use of regular expressions */

public class Regex {
    var internalExpression: NSRegularExpression?
    
    /**

    Default constructor
    
    @param pattern String containing a regular expression
    
    */
    public init(pattern: String) {
        self.internalExpression = NSRegularExpression(pattern: pattern, options: nil, error: nil)
    }
    
    /**

    Function used to test if an input matches the regular expression
    
    @param input String to be tested with the regular expression
    
    */
    public func matches(input: String) -> Bool {
        let matches = self.internalExpression!.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count > 0
    }
    
    /**

    Function used to replace the regular expression in an input by some other characters
    
    @param input String to be modified
    
    @param template String to replace the matching parts of the input with
    
    */
    public func replace(input: String, template: String) -> String {
        return self.internalExpression!.stringByReplacingMatchesInString(input, options: nil, range: NSMakeRange(0, count(input)), withTemplate: template)
    }
}