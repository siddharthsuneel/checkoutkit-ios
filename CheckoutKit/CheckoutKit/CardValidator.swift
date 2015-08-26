//
//  CardValidator.swift
//  Pods
//
//  Created by Manon Henrioux on 19/08/2015.
//
//

import Foundation

///  Class containing verification methods about cards numbers, CVV, expiry dates, and useful constants about card types

public class CardValidator {
    
    /* Regular expression used for sanitizing the card's name */
    public static let CARD_NAME_REPLACE_PATTERN = "[^A-Z\\s]";
    
    /*
    
    Test if the string is composed exclusively of digits
    
    :param: entry : String to be tested
    
    :returns: result of the test
    
    */
    
    private class func isDigit(entry: String) -> Bool {
        return Regex(pattern: "^\\d+$").matches(entry)
    }
    
    /**
    
    Sanitizes any string given as a parameter
    
    :param: entry : String to be cleaned
    
    :param: isNumber : boolean, if set, the method removes all non digit characters, otherwise only the - and spaces
    
    :returns: cleaned string
    
    */
    
    public class func sanitizeEntry(entry: String, isNumber: Bool) -> String {
        let a: String = isNumber ? "\\D" : "\\s+|-"
        return Regex(pattern: a).replace(entry, template: "")
    }
    
    /*
    
    Sanitizes the card's name using the regular expression above
    
    :param: entry : String to be cleaned
    
    :returns: cleaned string
    
    */
    
    private class func sanitizeName(entry: String) -> String {
        return Regex(pattern: CARD_NAME_REPLACE_PATTERN).replace(entry.uppercaseString, template: "")
    }
    
    /**
    
    Returns the CardInfo element corresponding to the given number
    
    :param: number : String containing the card's number
    
    :returns: CardInfo element corresponding to num or null if it was not recognized
    
    */
    
    public class func getCardType(number: String) -> CardInfo? {
        var n = sanitizeEntry(number, isNumber: true)
        if Regex(pattern: "^(54)").matches(n) && count(n) > 16 {
            return CardInfo.MAESTRO
        }
        for c in CardInfo.cards {
            if Regex(pattern: c.pattern).matches(n) {
                return c
            }
        }
        return nil
    }
    
    /*
    
    Applies the Luhn Algorithm to the given card number
    
    :param: number : String containing the card's number to be tested
    
    :returns: boolean containing the result of the computation
    
    */
    
    private class func validateLuhnNumber(number: String) -> Bool {
        if number == "" { return false }
        var nCheck: Int = 0
        var nDigit: Int? = 0
        var even = false
        var n = sanitizeEntry(number, isNumber: true)
        var array = Array(n)
        for var i = (array.count - 1) ; i >= 0 ; i-- {
            nDigit = String(array[i]).toInt()
            if nDigit == nil {
                return false
            }
            
            if even {
                nDigit = nDigit! * 2
                if nDigit > 9 { nDigit = nDigit! - 9 }
            }
            nCheck = nCheck + nDigit!
            even = !even
        }
        return (nCheck%10) == 0
    }
    
    /**
    
    Checks if the card's number is valid by identifying the card's type and checking its conditions
    
    :param: number : String containing the card's code to be verified
    
    :returns: boolean containing the result of the verification
    
    */
    
    public class func validateCardNumber(number: String) -> Bool {
        if number == "" { return false }
        var n = sanitizeEntry(number, isNumber: true)
        if Regex(pattern: "^\\d+$").matches(n) {
            var c = getCardType(n)
            if c != nil {
                var len = false
                for i in c!.cardLength {
                    if count(n) == i {
                       len = true
                        break
                    }
                }
                return len && (c!.luhn == false || validateLuhnNumber(n))
            }
        }
        return false
    }
    
    /**
    
    Checks if the card is still valid
    
    :param: month : String containing the expiring month of the card
    
    :param: year : String containing the expiring year of the card
    
    :returns: boolean containing the result of the verification
    
    */
    
    public class func validateExpiryDate(month: String, year: String) -> Bool {
        if count(year) != 2 && count(year) != 4 { return false }
        var m: Int? = month.toInt()
        var y: Int? = year.toInt()
        if m != nil && y != nil {
            return validateExpiryDate(m!, year: y!)
        }
        return false
    }
    
    /**
    
    Checks if the card is still valid
    
    :param: month : int containing the expiring month of the card
    
    :param: year : int containing the expiring year of the card
    
    :returns: boolean containing the result of the verification
    
    */
    
    public class func validateExpiryDate(month: Int, year: Int) -> Bool {
        if month < 1 || year < 1 { return false }

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitMonth | .CalendarUnitYear, fromDate: date)
        var curMonth = components.month
        var curYear = components.year
        if year < 100 { curYear = curYear - 2000 }
        return (curYear == year) ? curMonth <= month : curYear < year
    }
    
    /**
    
    Checks if the CVV is valid for a given card's type
    
    :param: cvv : String containing the value of the CVV
    
    :param: card : Cards element containing the card's type
    
    :returns: boolean containing the result of the verification
    
    */
    
    public class func validateCVV(cvv: String, card: CardInfo) -> Bool {
        if cvv == "" { return false }
        let len = count(cvv)
        for i in card.cvvLength {
            if len == i { return true }
        }
        return false
    }
    
    /**
    
    Checks if the CVV is valid for a given card's type
    
    :param: cvv : int containing the value of the CVV
    
    :param: card : Cards element containing the card's type
    
    :returns: boolean containing the result of the verification
    
    */
    
    public class func validateCVV(cvv: Int, card: CardInfo) -> Bool {
        return validateCVV(String(cvv), card: card)
    }
    
}


