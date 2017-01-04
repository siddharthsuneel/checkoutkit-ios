//
//  CardValidator.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 19/08/2015.
//
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/**  Class containing verification methods about cards numbers, CVV, expiry dates, and useful constants about card types */

open class CardValidator {
    
    /* Regular expression used for sanitizing the card's name */
    open static let CARD_NAME_REPLACE_PATTERN = "[^A-Z\\s]";
    
    /*
    
    Test if the string is composed exclusively of digits
    
    @param entry String to be tested
    
    @return result of the test
    
    */
    
    fileprivate class func isDigit(_ entry: String) -> Bool {
        return Regex(pattern: "^\\d+$").matches(entry)
    }
    
    /**
    
    Sanitizes any string given as a parameter
    
    @param entry String to be cleaned
    
    @param isNumber boolean, if set, the method removes all non digit characters, otherwise only the - and spaces
    
    @return cleaned string
    
    */
    
    open class func sanitizeEntry(_ entry: String, isNumber: Bool) -> String {
        let a: String = isNumber ? "\\D" : "\\s+|-"
        return Regex(pattern: a).replace(entry, template: "")
    }
    
    /*
    
    Sanitizes the card's name using the regular expression above
    
    @param entry String to be cleaned
    
    @return cleaned string
    
    */
    
    fileprivate class func sanitizeName(_ entry: String) -> String {
        return Regex(pattern: CARD_NAME_REPLACE_PATTERN).replace(entry.uppercased(), template: "")
    }
    
    /**
    
    Returns the CardInfo element corresponding to the given number
    
    @param number String containing the card's number
    
    @return CardInfo element corresponding to num or null if it was not recognized
    
    */
    
    open class func getCardType(_ number: String) -> CardInfo? {
        let n = sanitizeEntry(number, isNumber: true)
        if Regex(pattern: "^(54)").matches(n) && n.characters.count > 16 {
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
    
    @param number String containing the card's number to be tested
    
    @return boolean containing the result of the computation
    
    */
    
    fileprivate class func validateLuhnNumber(_ number: String) -> Bool {
        if number == "" { return false }
        var nCheck: Int = 0
        var nDigit: Int? = 0
        var even = false
        let n = sanitizeEntry(number, isNumber: true)
        var array = Array(n.characters)
        for i in (0 ..< (array.count)).reversed() {
            nDigit = Int(String(array[i]))
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
    
    @param number String containing the card's code to be verified
    
    @return boolean containing the result of the verification
    
    */
    
    open class func validateCardNumber(_ number: String) -> Bool {
        if number == "" { return false }
        let n = sanitizeEntry(number, isNumber: true)
        if Regex(pattern: "^\\d+$").matches(n) {
            let c = getCardType(n)
            if c != nil {
                var len = false
                for i in c!.cardLength {
                    if n.characters.count == i {
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
    
    @param month String containing the expiring month of the card
    
    @param year String containing the expiring year of the card
    
    @return boolean containing the result of the verification
    
    */
    
    open class func validateExpiryDate(_ month: String, year: String) -> Bool {
        if year.characters.count != 2 && year.characters.count != 4 { return false }
        let m: Int? = Int(month)
        let y: Int? = Int(year)
        if m != nil && y != nil {
            return validateExpiryDate(m!, year: y!)
        }
        return false
    }
    
    /**
    
    Checks if the card is still valid
    
    @param month int containing the expiring month of the card
    
    @param year int containing the expiring year of the card
    
    @return boolean containing the result of the verification
    
    */
    
    open class func validateExpiryDate(_ month: Int, year: Int) -> Bool {
        if month < 1 || year < 1 { return false }

        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.month, .year], from: date)
        let curMonth = components.month
        var curYear = components.year
        if year < 100 { curYear = curYear! - 2000 }
        return (curYear! == year) ? curMonth! <= month : curYear! < year
    }
    
    /**
    
    Checks if the CVV is valid for a given card's type
    
    @param cvv String containing the value of the CVV
    
    @param card Cards element containing the card's type
    
    @return boolean containing the result of the verification
    
    */
    
    open class func validateCVV(_ cvv: String, card: CardInfo) -> Bool {
        if cvv == "" { return false }
        let len = cvv.characters.count
        for i in card.cvvLength {
            if len == i { return true }
        }
        return false
    }
    
    /**
    
    Checks if the CVV is valid for a given card's type
    
    @param cvv int containing the value of the CVV
    
    @param card Cards element containing the card's type
    
    @return boolean containing the result of the verification
    
    */
    
    open class func validateCVV(_ cvv: Int, card: CardInfo) -> Bool {
        return validateCVV(String(cvv), card: card)
    }
    
}


