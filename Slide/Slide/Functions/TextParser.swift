//
//  TextVerification.swift
//  Slide
//
//  Created by Valeriy Soltan on 6/6/19.
//  Copyright © 2019 Roodac. All rights reserved.
//

import UIKit
import Foundation

class TextParser {

    // sets the placeholder text to red and displays an appropriate error message
    static func emptyError(field: UITextField, error: String) {
        field.attributedPlaceholder = NSAttributedString(string: error, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
    }
    
    // verifies the format and completion of a text field entry
    static func validate(textFields: Array<(field: UITextField, type: String)>) -> Bool {
        
        var completeForm : Bool = true
        
        // iterates through each textfield and checks if its empty
        for entry in textFields {
            if (entry.field.text!.isEmpty){
                emptyError(field: entry.field, error: "please enter your \(entry.type)")
                completeForm = false
            }
            
            // regex email matching
            if (entry.type.equals(id: "email") && !((entry.field.text!).trim().isValidEmail())) {
                CustomError.createWith(errorTitle: "Invalid Email", errorMessage: "Please enter a valid email address").show()
                completeForm = false
            }
        }
        return completeForm
    }
    
    static func validate(phoneNumber: String) -> Bool {
        return phoneNumber.isValidPhoneNumber()
    }
    
    static func splitName(fullName: String) -> (first: String, last: String) {
        let split = fullName.lastIndex(of: " ")
        let range = fullName.distance(from: fullName.startIndex, to: split!)
        return (fullName[0..<range], fullName[range..<fullName.count])
    }
}

extension String {
    // string equality method for readability
    func equals(id: String) -> Bool {
        return String(format: self) == id
    }
    
    // substring
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

// establishes the format for accepted emails
extension String {
    // checks that an email string conforms to styling and format standards
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPhoneNumber() -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }
    
    // removes whitespace from the beginning and end of the string
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}


